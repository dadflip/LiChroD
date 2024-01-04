import os
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
import tkinter
root = Tk()
#^ width - heghit window :D
cmb = ttk.Combobox(root, width="10", values=("Update APT packages", "Ugrade APT packages", "Update FLATPAK", "Quitter"))
#cmb = Combobox

class TableDropDown(ttk.Combobox):

    def __init__(self, parent):
        self.current_table = tkinter.StringVar() # create variable for table
        ttk.Combobox.__init__(self, parent)#  init widget
        self.config(textvariable = self.current_table, state = "readonly", values = ["Customers", "Pets", "Invoices", "Prices"])
        self.current(0) # index of values for current table
        self.place(x = 50, y = 50, anchor = "w") # place drop down box 
    
    
    
def checkcmbo():
    
    if cmb.get() == "Update APT packages":
        os.system('xterm -e sudo apt update')
        messagebox.showinfo("Info", "Packages Updated Successfully")
    elif cmb.get() == "Ugrade APT packages":
        os.system('xterm -e sudo apt -y upgrade')
        messagebox.showinfo("Info", "Packages Updgraded Successfully")
    elif cmb.get() == "Update FLATPAK":
        os.system('xterm -e sudo flatpak -y update')
        messagebox.showinfo("Info", "Flatpak Updated Successfully")
    elif cmb.get() == "Quitter":
        quit
    elif cmb.get() == "":
        messagebox.showerror("nothing to show!", "You have to be choose something")
        
        
#termf = Frame(root, height=200, width=455)
#termf.pack(expand=YES)
#wid = termf.winfo_id()
#os.system('xterm -into %d -geometry 600x400 -sb &' % wid)

cmb.place(relx="0.29",rely="0.3", width=200)
btn = ttk.Button(root, text="Valider",command=checkcmbo)
btn.place(relx="0.63",rely="0.3")

#personnalisation
root.title("Packages Manager")
root.geometry("1080x720")
root.minsize(480, 360)
root.config(background='black')
root.minsize(1080, 720)


root.mainloop()