import gleam/list
import gleam/option
import gleam/string

/// Alias to `Result(Nil, Failure)` for convenience
pub type ValidationResult =
  Result(Nil, Failure)

/// The different types of failure messages, these can be used to later build human readable messages like:
/// `The string "John" expected to be longer then 10 characters but was actually 4`
pub type Failure {
  /// Returned when is_gt failed
  IsGreaterFailure(value: Int, expected: Int)
  /// Returned when is_gte failed
  IsGreaterOrEqualFailure(value: Int, expected: Int)
  /// Returned when is_longer failed
  IsLongerFailure(value: String, actual: Int, expected: Int)
  /// Returned when is_lt failed
  IsLesserFailure(value: Int, expected: Int)
  /// Returned when is_lte failed
  IsLesserOrEqualFailure(value: Int, expected: Int)
  /// Returned when is_equal failed
  IsEqualFailure(value: String, expected: String)
  /// Returned when is_included_in failed
  IsIncludedInFailure(value: String, expected: String)
  /// Returned when is_true/is_false failed
  IsBoolFailure(value: Bool, expected: Bool)
  /// Returned when is_some failed
  IsSomeFailure
  /// Returned when is_none failed
  IsNoneFailure(value: String)
  // Type used to contain custom failures
  CustomFailure(message: String)
}

/// The `ValidationError` type consists of the field name and the error
pub type ValidationError {
  ValidationError(field: String, failure: Failure)
}

/// The `Okay` type is used to store the list of validation failures
pub type Okay {
  Okay(failures: List(ValidationError))
}

/// Checks if the `Okay` record contains any failures and responds with a Result
pub fn run(okay: Okay) -> Result(Nil, Okay) {
  case list.is_empty(okay.failures) {
    True -> Ok(Nil)
    False -> Error(okay)
  }
}

/// Initializes a `Okay` record with an empty list of failures
pub fn new() -> Okay {
  Okay(failures: [])
}

/// Based on the validation function result, it'll append the Error to the `Okay.failures` list
/// The `field` argument is just used as an identifier and will be paired with the error at the end
pub fn field(okay: Okay, field: String, result: ValidationResult) -> Okay {
  case result {
    Error(failure) -> {
      let updated_failures =
        list.append(okay.failures, [ValidationError(field:, failure:)])

      Okay(failures: updated_failures)
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
pub fn is_included_in(value: t, whitelist: List(t)) -> ValidationResult {
  case list.contains(whitelist, value) {
    True -> Ok(Nil)
    False ->
      Error(IsIncludedInFailure(
        string.inspect(value),
        string.inspect(whitelist),
      ))
  }
}

/// Checks if string is longer than X amount
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_longer("hello", 1)
/// let assert Error(_error) = okay.is_longer("A", 2)
/// ```
///
pub fn is_longer(value: String, length: Int) -> ValidationResult {
  let value_length = string.length(value)
  case value_length > length {
    True -> Ok(Nil)
    False -> Error(IsLongerFailure(value, value_length, length))
  }
}

/// Checks if two values are equal to each other
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_equal("hi", "hi")
/// let assert Error(_error) = okay.is_equal(1, 2)
/// ```
///
pub fn is_equal(value: t, compare: t) -> ValidationResult {
  case value == compare {
    True -> Ok(Nil)
    False ->
      Error(IsEqualFailure(string.inspect(value), string.inspect(compare)))
  }
}

/// Checks if one Int is greater than another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_gt(10, 1)
/// let assert Error(_error) = okay.is_gt(1, 10)
/// ```
///
pub fn is_gt(value: Int, compare: Int) -> ValidationResult {
  case value > compare {
    True -> Ok(Nil)
    False -> Error(IsGreaterFailure(value, compare))
  }
}

/// Checks if one Int is greater than or equal to another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_gte(10, 10)
/// let assert Error(_error) = okay.is_gte(9, 10)
/// ```
///
pub fn is_gte(value: Int, compare: Int) -> ValidationResult {
  case value >= compare {
    True -> Ok(Nil)
    False -> Error(IsGreaterOrEqualFailure(value, compare))
  }
}

/// Checks if one Int is less than another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_lt(1, 2)
/// let assert Error(_error) = okay.is_lt(5, 1)
/// ```
///
pub fn is_lt(value: Int, compare: Int) -> ValidationResult {
  case value < compare {
    True -> Ok(Nil)
    False -> Error(IsLesserFailure(value, compare))
  }
}

/// Checks if one Int is less than or equal to another
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_lte(8, 8)
/// let assert Error(_error) = okay.is_lte(9, 8)
/// ```
///
pub fn is_lte(value: Int, compare: Int) -> ValidationResult {
  case value <= compare {
    True -> Ok(Nil)
    False -> Error(IsLesserOrEqualFailure(value, compare))
  }
}

/// Checks if bool is True
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_true(True)
/// let assert Error(_error) = okay.is_true(False)
/// ```
///
pub fn is_true(value: Bool) -> ValidationResult {
  case value == True {
    True -> Ok(Nil)
    False -> Error(IsBoolFailure(value, True))
  }
}

/// Checks if bool is False
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_false(False)
/// let assert Error(_error) = okay.is_false(True)
/// ```
///
pub fn is_false(value: Bool) -> ValidationResult {
  case value == False {
    True -> Ok(Nil)
    False -> Error(IsBoolFailure(value, False))
  }
}

/// Checks if Option is Some
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_some(option.Some(1))
/// let assert Error(_error) = okay.is_some(option.None)
/// ```
///
pub fn is_some(value: option.Option(t)) -> ValidationResult {
  case value {
    option.Some(_) -> Ok(Nil)
    option.None -> Error(IsSomeFailure)
  }
}

/// Checks if Option is None
/// # Examples
/// ```gleam
/// let assert Ok(_) = okay.is_none(option.None)
/// let assert Error(_error) = okay.is_noe(option.Some(1))
/// ```
///
pub fn is_none(value: option.Option(t)) -> ValidationResult {
  case value {
    option.None -> Ok(Nil)
    option.Some(x) -> Error(IsNoneFailure(string.inspect(x)))
  }
}
