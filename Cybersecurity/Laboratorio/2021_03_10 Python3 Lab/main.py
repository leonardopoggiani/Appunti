from datetime import datetime
from icecream import ic
from tqdm import tqdm
import time
from tkinter import *


def time_format():
    return f'{datetime.now()}|> '


ic.configureOutput(prefix=time_format)
ic.configureOutput(includeContext=True)


class Window(Frame):
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.master = master


if __name__ == '__main__':
    root = Tk()
    app = Window(root)

    # set window title
    root.wm_title("Cybersecurity exercise")

    # Create a Button
    btn = Button(root, text='Close!', bd='5',
                 command=root.destroy)

    text = Text(root)
    text.insert(INSERT, "list comprehension: ")
    text.insert(INSERT, "a_power_j = [i**j for (i,j) in zip(a,e)]\n")
    text.insert(INSERT, "encoding a message in ASCII: \n")
    text.insert(INSERT, "txt.encode(encoding=\"ascii\",errors=\"backslashreplace\")\n")
    txt = "ciao a dopo"
    encoded = txt.encode(encoding='ascii', errors='backslashreplace')
    text.insert(INSERT, f"text: \"ciao a dopo\" \n encoded: {txt.encode(encoding='ascii',errors='backslashreplace')}"
                        f"\n decoded: {encoded.decode('ascii')}")
    text.pack()

    # Set the position of button on the top of window.
    btn.pack(side='bottom')

    # show window
    root.mainloop()
