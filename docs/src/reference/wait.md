# wait

`wait` checks every 0.1s for the block to return `true` or "anything but false" until `max_seconds` has elapsed. Quits the script with an error if the wait condition is not satisfied.

```ruby
wait max_seconds do
  # true or anything but false
end
```


### Examples

Wait maximum of 3 seconds for the text 'Example Domain' to appear on the page.

```ruby
visit 'example.com'

wait 3 do
  has_text? 'Example Domain'
end
```

Wait up to 3.3 seconds for a `<div id='login'>` to appear and assign it to a variable for clicking.

```ruby
login = wait 3.3 do
  find 'div#login'
end

login.click
```

