from tkinter import *
from subprocess import call
import os
from tkinter.messagebox import *
from tkinter.filedialog import *


#creation fenetre
fenetre = Tk()

#personnalisation
fenetre.title("My App")
fenetre.geometry("1080x720")
fenetre.minsize(480, 360)
fenetre.config(background='black')

filepath = askopenfilename(title="Ouvrir une image",filetypes=[('png files','.png'),('all files','.*')])
photo = PhotoImage(file=filepath)
canvas = Canvas(fenetre, width=photo.width(), height=photo.height(), bg="white")
canvas.create_image(0, 0, anchor=NW, image=photo)
canvas.pack()

#affichage
fenetre.mainloop()