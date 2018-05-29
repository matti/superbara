# assert

`assert` _asserts_ that the block is truthy at the given time. The first parameter is an optional failure message.

```ruby
assert 'login missing' do
  has_text? 'Login'
end
```


### Examples

Check that example.com still has the same heading.

```ruby
visit 'example.com'

assert 'somebody changed the text!'
  h1 = find 'h1'
  h1.text == 'Example Domain'
end
```

Asserts can also be written without the message.

```ruby
assert do
  has_text? "Something"
end
```

Negative asserts can also be given.

```ruby
assert do
  has_no_text? "Login"
end

# or
assert do
  !has_text? "Login"
end
```

## Related

 - [find](./reference/find.html)
