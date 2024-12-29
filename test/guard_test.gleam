import gleeunit
import gleeunit/should
import guard.{ValidationError}

pub fn main() {
  gleeunit.main()
}

pub type TestEntities {
  User(id: Int, name: String, age: Int)
}

pub fn run_test() {
  let user = User(id: 1, name: "John", age: 20)

  guard.new()
  |> guard.field("age", guard.is_gt(user.age, 18))
  |> guard.field("name", guard.is_longer(user.name, 1))
  |> guard.run()
  |> should.be_ok

  let assert Error(validator) =
    guard.new()
    |> guard.field("age", guard.is_gt(user.age, 30))
    |> guard.field("name", guard.is_longer(user.name, 5))
    |> guard.run()

  let assert [first, second] = validator.errors
  should.equal(first, ValidationError("age", guard.IsGreater(20, 30)))
  should.equal(second, ValidationError("name", guard.IsLonger("John", 4, 5)))
}

pub fn is_gt_test() {
  should.be_ok(guard.is_gt(2, 1))
  should.be_error(guard.is_gt(1, 1))
  should.be_error(guard.is_gt(0, 1))
}

pub fn is_gte_test() {
  should.be_ok(guard.is_gte(2, 1))
  should.be_ok(guard.is_gte(1, 1))
  should.be_error(guard.is_gte(0, 1))
}

pub fn is_lt_test() {
  should.be_ok(guard.is_lt(1, 2))
  should.be_error(guard.is_lt(1, 1))
  should.be_error(guard.is_lt(2, 1))
}

pub fn is_lte_test() {
  should.be_ok(guard.is_lte(1, 2))
  should.be_ok(guard.is_lte(1, 1))
  should.be_error(guard.is_lte(2, 1))
}

pub fn is_longer_test() {
  should.be_ok(guard.is_longer("bob", 1))
  should.be_error(guard.is_longer("bob", 3))
  should.be_error(guard.is_longer("bob", 4))
}

pub fn is_equal_test() {
  should.be_ok(guard.is_equal("bob", "bob"))
  should.be_ok(guard.is_equal(1, 1))
  should.be_ok(guard.is_equal(2.2, 2.2))
  should.be_ok(guard.is_equal(True, True))
  should.be_error(guard.is_equal("a", "b"))
  should.be_error(guard.is_equal(1, 2))
  should.be_error(guard.is_equal(1.1, 1.2))
  should.be_error(guard.is_equal(True, False))

  let assert Error(err) = guard.is_equal(True, False)
  should.equal(err, guard.IsEqual("True", "False"))
}

pub fn is_included_in_test() {
  should.be_ok(guard.is_included_in("john", ["john", "bob"]))
  should.be_ok(guard.is_included_in(1, [1, 2]))
  should.be_error(guard.is_included_in("mark", ["john"]))
  should.be_error(guard.is_included_in(0, [1, 2]))

  let assert Error(err) = guard.is_included_in(1, [2, 3, 4])
  should.equal(err, guard.IsIncludedIn("1", "[2, 3, 4]"))
}

pub fn is_true_test() {
  should.be_ok(guard.is_true(True))
  should.be_error(guard.is_true(False))

  let assert Error(err) = guard.is_true(False)
  should.equal(err, guard.IsBool(value: False, expected: True))
}

pub fn is_false_test() {
  should.be_ok(guard.is_false(False))
  should.be_error(guard.is_false(True))

  let assert Error(err) = guard.is_false(True)
  should.equal(err, guard.IsBool(value: True, expected: False))
}
