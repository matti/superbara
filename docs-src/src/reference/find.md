# find

To get a single element use `find`

```ruby
title = find 'h1'
```

For multiple results use `all`

```ruby
links = all 'h1'
```

See (results)[./results.md] for complete list of methods available for the returned element or elements.

## Advanced finding

```ruby
title = find 'h1', text: "Example Domain"
```
