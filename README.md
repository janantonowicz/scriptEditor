# Simple script editor for scripts writen in Swift language
## With ability to run them and see the output

After launching the application user can see two pannels side by side:
The left one is mainly a TextEditor with, 
a run / stop button 
> While the script is running the button changes function
and indicator whether the script is currently running (it's green when not and red when it is)

On the right there is a Output panel where user can see the results.
Any errors or warnings will be displayed bellow output.
After executing the script on the very bottom of the panel there is a message with exit code.

In the right top corner there is a shortcut button to settings where user can remove some keywords and define new one.
> Keywords are case sensitive! But can not be duplicated

Instead of TextEditor for user script input project uses custom NSTextView (CodeEditor.swift) to provide keywords highlighting functionality.
Keywords are stored in UserDefaults.

## Recording demo

https://github.com/user-attachments/assets/8633fc52-61f6-4d2d-8bd4-a7e0db22426a

