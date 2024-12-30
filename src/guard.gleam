import gleam/list
import gleam/string

// The different types of error messages, these can be used to later build human readable messages like:
// `The string "John" expected to be longer then 10 characters but was actually 4`
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

// The `ValidationError` type consists of the field name and the error
pub type ValidationError {
  ValidationError(field: String, error: Error)
}

// The `Guard` type is used to store the list of validation errors
pub type Guard {
  Guard(errors: List(ValidationError))
}

// Checks if the `Guard` record contains any errors and responds with a Result
pub fn run(guard: Guard) -> Result(Nil, Guard) {
  case list.is_empty(guard.errors) {
    True -> Ok(Nil)
    False -> Error(guard)
  }
}

// Initializes a `Guard` record with an empty list of errors
pub fn new() -> Guard {
  Guard(errors: [])
}

// Based on the validation function result, it'll append the Error to the `Guard.errors` list
pub fn field(guard: Guard, field: String, result: Result(Nil, Error)) -> Guard {
  case result {
    Error(error) -> {
      let updated_errors =
        list.append(guard.errors, [ValidationError(field:, error:)])

      Guard(errors: updated_errors)
    }
    _ -> guard
  }
}

// Checks if values is included in the list
// Example:
// let assert Ok(_) = guard.is_included_in(1, [1, 2])
// let assert Error(_error) = guard.is_included_in(3, [1, 2])
pub fn is_included_in(value: t, whitelist: List(t)) -> Result(Nil, Error) {
  case list.contains(whitelist, value) {
    True -> Ok(Nil)
    False ->
      Error(IsIncludedIn(string.inspect(value), string.inspect(whitelist)))
  }
}

// Checks if string is longer than X amount
// Example:
// let assert Ok(_) = guard.is_longer("hello", 1)
// let assert Error(_error) = guard.is_longer("A", 2)
pub fn is_longer(value: String, length: Int) -> Result(Nil, Error) {
  let value_length = string.length(value)
  case value_length > length {
    True -> Ok(Nil)
    False -> Error(IsLonger(value, value_length, length))
  }
}

// Checks if two values are equal to each other
// Example:
// let assert Ok(_) = guard.is_equal("hi", "hi")
// let assert Error(_error) = guard.is_equal(1, 2)
pub fn is_equal(value: t, compare: t) -> Result(Nil, Error) {
  case value == compare {
    True -> Ok(Nil)
    False -> Error(IsEqual(string.inspect(value), string.inspect(compare)))
  }
}

// Checks if one Int is greater than another
// Example:
// let assert Ok(_) = guard.is_gt(10, 1)
// let assert Error(_error) = guard.is_gt(1, 10)
pub fn is_gt(value: Int, compare: Int) -> Result(Nil, Error) {
  case value > compare {
    True -> Ok(Nil)
    False -> Error(IsGreater(value, compare))
  }
}

// Checks if one Int is greater than or equal to another
// Example:
// let assert Ok(_) = guard.is_gte(10, 10)
// let assert Error(_error) = guard.is_gte(9, 10)
pub fn is_gte(value: Int, compare: Int) -> Result(Nil, Error) {
  case value >= compare {
    True -> Ok(Nil)
    False -> Error(IsGreaterOrEqual(value, compare))
  }
}

// Checks if one Int is less than another
// Example:
// let assert Ok(_) = guard.is_lt(1, 2)
// let assert Error(_error) = guard.is_lt(5, 1)
pub fn is_lt(value: Int, compare: Int) -> Result(Nil, Error) {
  case value < compare {
    True -> Ok(Nil)
    False -> Error(IsLesser(value, compare))
  }
}

// Checks if one Int is less than or equal to another
// Example:
// let assert Ok(_) = guard.is_lte(8, 8)
// let assert Error(_error) = guard.is_lte(9, 8)
pub fn is_lte(value: Int, compare: Int) -> Result(Nil, Error) {
  case value <= compare {
    True -> Ok(Nil)
    False -> Error(IsLesserOrEqual(value, compare))
  }
}

// Checks if bool is True
// Example:
// let assert Ok(_) = guard.is_true(True)
// let assert Error(_error) = guard.is_true(False)
pub fn is_true(value: Bool) -> Result(Nil, Error) {
  case value == True {
    True -> Ok(Nil)
    False -> Error(IsBool(value, True))
  }
}

// Checks if bool is False
// Example:
// let assert Ok(_) = guard.is_false(False)
// let assert Error(_error) = guard.is_false(True)
pub fn is_false(value: Bool) -> Result(Nil, Error) {
  case value == False {
    True -> Ok(Nil)
    False -> Error(IsBool(value, False))
  }
}
