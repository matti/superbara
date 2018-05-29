# Results

## Single elements

```ruby
link = find 'a'
link.text
```

```ruby
link = find 'a'
link.show
```

```ruby
link = find 'a'
link.click
```


## Multiple elements

```ruby
paragraphs = all 'p'
paragraphs.show
```

```ruby
paragraphs = all 'p'
paragraphs.first.show
paragraphs.second.show
# ..
paragraphs.tenth.show

links = all 'a'
paragraphs.last.click
paragraphs.middle.click
paragraphs.random.click


# first
paragraphs[0].show
paragraphs[1].show
# ..
paragraphs[999].show

```

```ruby
link = all 'a'
link.click
```

