# Standard libraries
import logging
import os
import pickle  # nosec
import pprint
from typing import Any

# Third-party libraries
from numpy.typing import NDArray
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score
from pydantic import validate_call

# Internal modules
from .__version__ import __version__
from . import _utils as utils
from .config import ModelConfigPM

logger = logging.getLogger(__name__)


class SimpleModel:
    """A simple wrapper around a Linear Regression model for demonstration.

    Attributes:
        _MODEL_ARTIFACTS_DICT (dict[str, str]): Dictionary containing the model artifacts.

        config (ModelConfigPM   ): Configuration for the model. Defaults to 'ModelConfigPM()'.
        model  (LinearRegression): Linear Regression model. Defaults to 'LinearRegression()'.

    Methods:
        is_model_files_exist (): Checks if the model files exist in the specified directory.

        run                  (): Runs the Linear Regression model to train/predict values.
        train                (): Trains the Linear Regression model.
        predict              (): Predicts target values using the trained model.
        score                (): Calculates the R^2 (Euclidean distance) between the true and predicted values.
        is_similar           (): Checks if the similarity score is greater than or equal to the threshold.
        is_trained           (): Checks if the model is trained.
        save                 (): Saves the model files.
        load                 (): Loads the model files.
    """

    _MODEL_ARTIFACTS_DICT = {
        "model_filename": "model.pkl",
    }

    @validate_call
    def __init__(
        self,
        config: ModelConfigPM | dict[str, Any] | None = None,
        auto_load: bool = False,
        **kwargs: Any,
    ) -> None:
        """Initializer for the SimpleModel class.

        Args:
            config    (ModelConfigPM | dict[str, Any] | None, optional): Configuration for the model. Defaults to None.
            auto_load (bool                                 , optional):
                Indicates whether to load the model from the files. Defaults to False.
            **kwargs  (Any                                  , optional): Keyword arguments to update the configuration.
        """

        logger.debug(f"Initializing <{self.__class__.__name__}> model...")

        if not config:
            config = ModelConfigPM()

        self.config = config
        if kwargs:
            self.config = self.config.model_copy(update=kwargs)

        if auto_load and self.is_model_files_exist(
            models_dir=self.config.models_dir, model_name=self.config.modelName
        ):
            self.load()
        else:
            # https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LinearRegression.html
            self.model = LinearRegression()

        logger.debug(
            f"Initalized <{self.__class__.__name__}> model with version: '{__version__}'."
        )

    # STATIC METHODS
    @staticmethod
    @validate_call
    def is_model_files_exist(models_dir: str, model_name: str) -> bool:
        """Checks if the model files exist in the specified directory.

        Args:
            models_dir (str): Location of the models (multiple models can be stored in this directory).
            model_name (str): Name of the model which is also the sub-directory name.

        Returns:
            bool: True if the model files exist, False otherwise.
        """

        _model_dir = os.path.join(models_dir, model_name)
        if not os.path.isdir(_model_dir):
            return False

        _artifact_filenames = SimpleModel._MODEL_ARTIFACTS_DICT.values()
        for _artifact_filename in _artifact_filenames:
            _artifact_path = os.path.join(_model_dir, _artifact_filename)
            if not os.path.isfile(_artifact_path):
                return False

        return True

    # STATIC METHODS

    @validate_call(config={"arbitrary_types_allowed": True})
    def run(self, X: NDArray[Any], y: NDArray[Any] | None = None) -> NDArray[Any]:
        """Runs the Linear Regression model to train/predict values.
        (This method is a wrapper around the 'train' and 'predict' methods.)

        Args:
            X (NDArray[Any]             , required): Input features of shape (n_samples, n_features).
            y (Union[NDArray[Any], None], optional): Target values of shape (n_samples,). Defaults to None.

        Raises:
            RuntimeError: If the model is not trained and target values are not provided.

        Returns:
            NDArray[Any]: Predicted target values of shape (n_samples,).
        """

        if not self.is_trained():
            if y is None:
                raise RuntimeError(
                    f"'{self.config.modelName}' model is not trained, can not run model without target values!"
                )

            self.train(X=X, y=y)

        return self.predict(X=X)

    @validate_call(config={"arbitrary_types_allowed": True})
    def train(self, X: NDArray[Any], y: NDArray[Any]) -> None:
        """Trains the Linear Regression model.

        Args:
            X (NDArray[Any]): Input features of shape (n_samples, n_features).
            y (NDArray[Any]): Target values of shape (n_samples,).
        """

        logger.info("Training model...")
        self.model.fit(X=X, y=y)
        logger.info("Successfully trained the model.")

    @validate_call(config={"arbitrary_types_allowed": True})
    def predict(self, X: NDArray[Any]) -> NDArray[Any]:
        """Predicts target values using the trained model.

        Args:
            X (NDArray[Any]): Input features of shape (n_samples, n_features).

        Returns:
            NDArray[Any]: Predicted target values of shape (n_samples,).
        """

        logger.debug("Predicting values...")
        _results: NDArray[Any] = self.model.predict(X=X)
        logger.debug("Succesfully predicted values.")

        return _results

    @validate_call(config={"arbitrary_types_allowed": True})
    def score(self, y_true: NDArray[Any], y_pred: NDArray[Any]) -> float:
        """Calculates the R^2 (Euclidean distance) between the true and predicted values.

        Args:
            y_true (NDArray[Any]): True values of shape (n_samples,).
            y_pred (NDArray[Any]): Predicted values of shape (n_samples,).

        Returns:
            float: R^2 score.
        """

        logger.debug("Calculating R^2 score...")
        _score: float = r2_score(y_true=y_true, y_pred=y_pred)
        logger.debug(f"Succesfully calculated R^2 score: {_score}")

        return _score

    @validate_call(config={"arbitrary_types_allowed": True})
    def is_similar(
        self, X: NDArray[Any], y: NDArray[Any], threshold: float | None = None
    ) -> bool:
        """Checks similarity between input features and target values.

        Args:
            X         (NDArray[Any], required): Input features of shape (n_samples, n_features).
            y         (NDArray[Any], required): Target values of shape (n_samples,).
            threshold (float | None, optional): Threshold value for the similarity score. Defaults to None.

        Returns:
            bool: True if the similarity score is greater than or equal to the threshold, False otherwise.
        """

        if not threshold:
            threshold = self.config.threshold

        _predicitions: NDArray[Any] = self.predict(X=X)
        _similarity: float = self.score(y_true=y, y_pred=_predicitions)
        if _similarity >= threshold:
            return True

        return False

    def is_trained(self) -> bool:
        """Checks if the model is trained.

        Returns:
            bool: True if the model is trained, False otherwise.
        """

        if not hasattr(self, "model"):
            return False

        return hasattr(self.model, "coef_")

    def save(self) -> None:
        """Saves the model files.

        Raises:
            RuntimeError: If the model is not trained.
            Exception: If the model files could not be saved.
        """

        try:
            if not self.is_trained():
                raise RuntimeError(
                    f"'{self.config.modelName}' model is not trained, can not save model!"
                )
        except RuntimeError as err:
            logger.error(err)
            raise

        logger.info(f"Saving '{self.config.modelName}' model files...")
        try:
            _model_dir = os.path.join(self.config.models_dir, self.config.modelName)
            utils.create_dir(_model_dir)

            _model_filename = SimpleModel._MODEL_ARTIFACTS_DICT["model_filename"]
            _model_path = os.path.join(_model_dir, _model_filename)
            with open(_model_path, "wb") as _model_file:
                pickle.dump(self.model, _model_file)

        except Exception:
            logger.error(f"Failed to save '{self.config.modelName}' model files.")
            raise
        logger.info(f"Successfully saved '{self.config.modelName}' model files.")

    def load(self) -> None:
        """Loads the model files.

        Raises:
            FileNotFoundError: If the model files do not exist.
            Exception: If the model files could not be loaded.
        """

        try:
            if not self.is_model_files_exist(
                models_dir=self.config.models_dir, model_name=self.config.modelName
            ):
                raise FileNotFoundError(
                    f"'{self.config.modelName}' model files does not exist, can not load model!"
                )
        except FileNotFoundError as err:
            logger.error(err)
            raise

        logger.info(f"Loading '{self.config.modelName}' model files...")
        try:
            _model_dir = os.path.join(self.config.models_dir, self.config.modelName)
            _model_filename = SimpleModel._MODEL_ARTIFACTS_DICT["model_filename"]
            _model_path = os.path.join(_model_dir, _model_filename)
            with open(_model_path, "rb") as _model_file:
                self.model = pickle.load(_model_file)  # nosec

        except Exception:
            logger.error(f"Failed to load '{self.config.modelName}' model files.")
            raise
        logger.info(f"Successfully loaded '{self.config.modelName}' model files.")

    # ATTRIBUTES
    # config
    @property
    def config(self) -> ModelConfigPM:
        try:
            return self.__config
        except AttributeError:
            self.__config = ModelConfigPM()

        return self.__config

    @config.setter
    def config(self, config: ModelConfigPM | dict[str, Any]) -> None:
        if (not isinstance(config, ModelConfigPM)) and (not isinstance(config, dict)):
            raise TypeError(
                f"`config` attribute type {type(config)} is invalid, must be a <class 'ModelConfigPM'> or <dict>"
            )

        if isinstance(config, dict):
            config = ModelConfigPM(**config)
        elif isinstance(config, ModelConfigPM):
            config = config.model_copy(deep=True)

        self.__config = config

    # config

    # model
    @property
    def model(self) -> LinearRegression:
        try:
            return self.__model
        except AttributeError:
            raise AttributeError("`model` attribute is not set!")

    @model.setter
    def model(self, model: LinearRegression) -> None:
        if not isinstance(model, LinearRegression):
            raise TypeError(
                f"`model` attribute type {type(model)} is invalid, must be a <class 'LinearRegression'>."
            )

        self.__model = model

    # model
    # ATTRIBUTES

    # METHOD OVERRIDING
    def __str__(self):
        _self_dict = utils.clean_obj_dict(self.__dict__, self.__class__.__name__)
        _self_str = f"{self.__class__.__name__}: {pprint.pformat(_self_dict)}"
        return _self_str

    def __repr__(self):
        _self_repr = utils.obj_to_repr(self)
        return _self_repr

    # METHOD OVERRIDING


__all__ = ["SimpleModel"]
