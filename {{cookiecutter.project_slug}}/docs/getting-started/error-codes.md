---
title: "Error Codes"
---

# 🚨 Error Codes

## Error Handling

Pydantic will raise a `ValidationError` whenever it finds an error in the data it's validating.

```python
from pydantic import ValidationError

from {{cookiecutter.module_name}} import SimpleModel


try:
    model = SimpleModel(config={"models_dir": "", "model_name": True, "threshold": 100})
except ValidationError as err:
    print(err)
```

The error message will look like this:

```txt
3 validation errors for ModelConfigPM
models_dir
  String should have at least 2 characters [type=string_too_short, input_value='', input_type=str]
    For further information visit https://errors.pydantic.dev/2.9/v/string_too_short
model_name
  Input should be a valid string [type=string_type, input_value=True, input_type=bool]
    For further information visit https://errors.pydantic.dev/2.9/v/string_type
threshold
  Input should be less than or equal to 1 [type=less_than_equal, input_value=100, input_type=int]
    For further information visit https://errors.pydantic.dev/2.9/v/less_than_equal
```
