#!/usr/bin/env python

# Standard libraries
import os
import sys
import logging
import pathlib
from typing import Any

# Third-party libraries
import numpy as np
from numpy.typing import NDArray

# Internal modules
from simple_model import SimpleModel

logger = logging.getLogger(__name__)


def main() -> None:
    logging.basicConfig(
        stream=sys.stdout,
        level=logging.INFO,
        datefmt="%Y-%m-%d %H:%M:%S %z",
        format="[%(asctime)s | %(levelname)s | %(filename)s:%(lineno)d]: %(message)s",
    )

    # Pre-defined variables (for customizing and testing)
    _parent_dir = pathlib.Path(__file__).parent.resolve()
    _models_dir = str(_parent_dir.parent.parent / "models")

    if not os.path.isdir(_models_dir):
        os.makedirs(_models_dir, exist_ok=True)

    _model_name = "linear_regression.v0.0.1-250101"

    _X_train = np.array([[1], [2], [3], [4], [5]])
    _y_train = np.array([2, 4, 6, 8, 10])

    _X_test = np.array([[6], [7], [8]])
    _y_test = np.array([10, 14, 16])

    # Main example
    logger.info("Creating and training a simple model...")

    # Create the model instance
    _config = {"models_dir": _models_dir, "model_name": _model_name}
    _model = SimpleModel(config=_config)

    # Train or load the model
    if not SimpleModel.is_model_files_exist(**_config):
        _model.train(X=_X_train, y=_y_train)
    else:
        _model.load()

    # Predict the target values
    _y_pred: NDArray[Any] = _model.predict(X=_X_test)
    logger.info(f"Predicted values for {_X_test.flatten()}: {_y_pred.flatten()}")

    # Evaluate the model
    _r2_score: float = _model.score(y_true=_y_test, y_pred=_y_pred)
    logger.info(f"R^2 score: {_r2_score}")

    _is_similar: bool = _model.is_similar(X=_X_test, y=_y_test)
    logger.info(f"Is similar: {_is_similar}")

    # Save the model
    if _model.is_trained() and (not SimpleModel.is_model_files_exist(**_config)):
        _model.save()

    logger.info("Done!\n")
    return


if __name__ == "__main__":
    main()
