#!usr/bin/python
# -*- coding: utf-8 -*-

import tkinter as tk
from tkinter import *
from tkinter import filedialog
from tkinter.messagebox import *
from tkinter.filedialog import *

class App(tk.Tk):

    def __init__(self):
        tk.Tk.__init__(self)

        #configuration de la fenetre
        self.configure(bg='purple')
        self.geometry('600x400')

        #configuration du Grid pour redimensionner les widgets en fonction de la fenetre
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(1, weight=1)

        #initialisation de widjets
        self.initWidgets()

    def initWidgets(self):
        menubar = tk.Menu(self, bg="black", fg='white')
        self.config(menu=menubar)
 
        file_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Fichier", menu=file_menu)
        file_menu.add_command(label="Ouvrir", command=self.openFile)
        file_menu.add_command(label="Enregistrer", command=self.saveFile)
 
        self.bt_open = tk.Button(self, text="Ouvrir fichier", command=self.openFile)
        self.bt_open.grid(row=0, column=0)
 
        self.text = tk.Text(self, width=80, height=30, bg="black", fg="white")
        self.text.grid(row=1, column=0)
 
        self.bind("<Configure>", self.resize)    # appelle resize() quand la fenêtre est redimensionnée
 
        

    def openFile(self):
        filepath = filedialog.askopenfilename(filetypes=[('txt files','.txt'),('all files','.*')])

        with open(filepath, 'r') as FILE:
            content = FILE.read()

        self.filepath = filepath
        self.text.insert("end", content)

    def saveFile(self):
        filepath = self.filepath
        content = self.text.get("1.0", "end")

        if self.filepath:
            try:
                with open(filepath, 'w') as FILE:
                    FILE.write(content)
            except:
                tk.messagebox.showerror("Erreur", "Une erreur est survenue lors de l'enregistrement")
            else:
                self.filepath = filedialog.askopenfilename(filetypes=[('txt files','.txt'),('all files','.*')])
                tk.messagebox.showinfo("Enregistré", "Modifications enregistrées avec succès")
        
        else:
            tk.messagebox.showerror("Erreur", "Une erreur est survenue lors de l'enregistrement")
            

    def resize(self,event):
            # s'assurer que le widget remplit la fenêtre à chaque redimensionnement
            self.bt_open.grid(sticky=tk.N+tk.S+tk.E+tk.W)
            self.text.grid(sticky=tk.N+tk.S+tk.E+tk.W)
        
    
 
#------------------------------------------------------------------------------
if __name__ == '__main__':
    app = App()
    app.mainloop()
