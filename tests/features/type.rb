run "../common"

textarea = find "textarea"
textarea.type "hello", :backspace, :backspace, "sinki", :enter
