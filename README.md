# Superbara

Web app test scripting that does not hurt.

 - Stands on the shoulders of [Capybara](https://github.com/teamcapybara/capybara/)
 - All batteries included: just start scripting, nothing extra required
 - A powerful command line interface with interactive debugger
 - The most natural test language that is still programming, see:

```ruby
visit "mysite.com"
wait 3 do
  has_text? "welcome"
end

scroll 20
click_link "enter"

name_field = find "input#name"
name_field.type "Sarah", :enter

if has_text? "Welcome, Sarah"
  run "logout"
else
  assert "no greeting visible"
end
```

## Install & Usage

```shell
gem install superbara
superbara init example
superbara start example
superbara usage
```

## Some things that Superbara does that Capybara does not:

```ruby
# find+click in one line!
click 'h1'

# wait up to 3 seconds for block to return something else than nil or false
wait 3 do
  has_text? "Welcome"
end

wait 3.1 do
  find "#username"
end

# simulates real typing
textarea = find "textarea"
textarea.type "hello", :backspace, :backspace, :backspace, "sinki", :enter

# scrolling
scroll 50
scroll -20, duration: 4

# works also without http://
visit 'example.com'

# highlights when in interactive mode or SUPERBARA_VISUAL env is set
find "h1"

# runs project/file.rb
run "vars"

# possible to run just once per session (superbara start) to speed up
run "login", once: true

# ..and do something when already ran
run "login", once: true do
  # when already logged in
  visit "http://www.example.com/main"
end

# opens debugger when exception happens or when the test finishes or
debug

# back, forward, reload (and not only go_back, go_forward, refresh)
back
forward
reload

# natural sleeps, sleep between 2 and 4 seconds
think 2..4
```

Everything that works in Capybara, works in Superbara, see https://github.com/teamcapybara/capybara/#the-dsl

Quick Reference:
```
click_link 'id-of-link'
click_link 'Link Text'
click_button 'Save'
click_on 'Link Text' || click_on 'Button Value'
click_text 'get started'

find 'h1'
find_field('First Name').value
find_field(id: 'my_field').value
find_link('Hello', :visible => :all).visible?
find_link(class: ['some_class', 'some_other_class'], visible: :all).visible?

find_button('Send').click
find_button(value: '1234').click

find(:xpath, ".//table/tr").click
find("#overlay").find("h1").click
for a in all('a') do
  if a[:href].include? "about"
    a.click
  end
end

img_boxed = find('img') do |el|
  el['data-box'] == true
end

within '#menu' do
  click 'a', text: 'Pricing'
end

within_table 'Employee' do
  fill_in 'Name', with: 'Sarah'
end

within_fieldset 'Employee' do
  ...
end

facebook_window = window_opened_by do
  click_button 'Like'
end

within_window facebook_window do
  find('#login_email').type 'a@example.com'
  find('#login_password').type 'qwerty'
  click_button 'Submit'
end

execute_script "document.querySelector("#name").style.border = '1px solid red';"

value = evaluate_script "window.innerHeight"

accept_alert do
  click_link 'Show Alert'
end

dismiss_confirm do
  click_link 'Show Confirm'
end

message = accept_prompt with: 'Linda Liukas' do
  click_link 'Author Quiz!'
end
message = 'Who is the author of Hello Ruby?'

has_selector? 'table tr'
has_no_selector? 'table tr'

has_selector? :xpath, './/table/tr'

has_xpath? './/table/tr'
has_no_xpath? './/table/tr'
has_css? 'table tr.foo'
has_no_css? 'table tr.foo'

has_content? 'foo'
has_no_content? 'foo'
has_text? 'foo'
has_no_text? 'foo'

fill_in 'First Name', with: 'Johwn'
choose 'A Radio Button'
check 'A Checkbox'
uncheck 'A Checkbox'
attach_file 'Image', File.join(Dir.pwd,'image.jpg')
select 'Option', from: 'Select Box'
```
