import gleam/list
import gleam/string

/// The different types of error messages, these can be used to later build human readable messages like:
/// `The string "John" expected to be longer then 10 characters but was actually 4`
pub type Error {
  IsGreater(value: Int, expected: Int)
  IsGreaterOrEqual(value: Int, expected: Int)
  IsLonger(value: String, actual: Int, expected: Int)
  IsLesser(value: Int, expected: Int)
  IsLesserOrEqual(value: Int, expected: Int)
  IsEqual(value: String, expected: String)
  IsIncludedIn(value: String, expected: String)
  IsBool(value: Bool, expected: Bool)
}

/// The `ValidationError` type consists of the field name and the error
pub type ValidationError {
  ValidationError(field: String, error: Error)
}

/// The `Okay` type is used to store the list of validation errors
pub type Okay {
  Okay(errors: List(ValidationError))
}

/// Checks if the `Okay` record contains any errors and responds with a Result
pub fn run(okay: Okay) -> Result(Nil, Okay) {
  case list.is_empty(okay.errors) {
    True -> Ok(Nil)
    False -> Error(okay)
  }
}

/// Initializes a `Okay` record with an empty list of errors
pub fn new() -> Okay {
  Okay(errors: [])
}

/// Based on the validation function result, it'll append the Error to the `Okay.errors` list
pub fn field(okay: Okay, field: String, result: Result(Nil, Error)) -> Okay {
  case result {
    Error(error) -> {
      let updated_errors =
        list.append(okay.errors, [ValidationError(field:, error:)])

      Okay(errors: updated_errors)
    }
    _ -> okay
  }
}

/// Checks if values is included in the list
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_included_in(1, [1, 2])
/// let assert Error(_error) = okay.is_included_in(3, [1, 2])
/// ```
///
pub fn is_included_in(value: t, whitelist: List(t)) -> Result(Nil, Error) {
  case list.contains(whitelist, value) {
    True -> Ok(Nil)
    False ->
      Error(IsIncludedIn(string.inspect(value), string.inspect(whitelist)))
  }
}

/// Checks if string is longer than X amount
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_longer("hello", 1)
/// let assert Error(_error) = okay.is_longer("A", 2)
/// ```
///
pub fn is_longer(value: String, length: Int) -> Result(Nil, Error) {
  let value_length = string.length(value)
  case value_length > length {
    True -> Ok(Nil)
    False -> Error(IsLonger(value, value_length, length))
  }
}

/// Checks if two values are equal to each other
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_equal("hi", "hi")
/// let assert Error(_error) = okay.is_equal(1, 2)
/// ```
///
pub fn is_equal(value: t, compare: t) -> Result(Nil, Error) {
  case value == compare {
    True -> Ok(Nil)
    False -> Error(IsEqual(string.inspect(value), string.inspect(compare)))
  }
}

/// Checks if one Int is greater than another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_gt(10, 1)
/// let assert Error(_error) = okay.is_gt(1, 10)
/// ```
///
pub fn is_gt(value: Int, compare: Int) -> Result(Nil, Error) {
  case value > compare {
    True -> Ok(Nil)
    False -> Error(IsGreater(value, compare))
  }
}

/// Checks if one Int is greater than or equal to another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_gte(10, 10)
/// let assert Error(_error) = okay.is_gte(9, 10)
/// ```
///
pub fn is_gte(value: Int, compare: Int) -> Result(Nil, Error) {
  case value >= compare {
    True -> Ok(Nil)
    False -> Error(IsGreaterOrEqual(value, compare))
  }
}

/// Checks if one Int is less than another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_lt(1, 2)
/// let assert Error(_error) = okay.is_lt(5, 1)
/// ```
///
pub fn is_lt(value: Int, compare: Int) -> Result(Nil, Error) {
  case value < compare {
    True -> Ok(Nil)
    False -> Error(IsLesser(value, compare))
  }
}

/// Checks if one Int is less than or equal to another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_lte(8, 8)
/// let assert Error(_error) = okay.is_lte(9, 8)
/// ```
///
pub fn is_lte(value: Int, compare: Int) -> Result(Nil, Error) {
  case value <= compare {
    True -> Ok(Nil)
    False -> Error(IsLesserOrEqual(value, compare))
  }
}

/// Checks if bool is True
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_true(True)
/// let assert Error(_error) = okay.is_true(False)
/// ```
///
pub fn is_true(value: Bool) -> Result(Nil, Error) {
  case value == True {
    True -> Ok(Nil)
    False -> Error(IsBool(value, True))
  }
}

/// Checks if bool is False
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_false(False)
/// let assert Error(_error) = okay.is_false(True)
/// ```
///
pub fn is_false(value: Bool) -> Result(Nil, Error) {
  case value == False {
    True -> Ok(Nil)
    False -> Error(IsBool(value, False))
  }
}
