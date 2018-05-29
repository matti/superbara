# has_text?

Checks if the text is found on the screen.

```ruby
assert do
  has_text? "Welcome"
end
```

# Examples

```ruby
if has_text? "Logged in"
  click_link "Log out"

  wait 3 do
    has_text? "You have logged out"
  end
else
  click_link "Next"
end
```

