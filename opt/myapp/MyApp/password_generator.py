from random import choice, randint
from tkinter import *
from turtle import st, width
import string


def generate_password():
    passwd_min = 6
    passwd_max = 12
    all_chars = string.ascii_letters + string.punctuation + string.digits

    password = "".join(choice(all_chars) for x in range (randint(passwd_min,passwd_max)))
    password_entry.delete(0, END)
    password_entry.insert(0, password)




window = Tk()
window.title("Password Generator")
window.minsize(1080, 720)
window.config(background='purple')

#frame principale
frame = Frame(window, bg='white')



#génération image
width = 300
height = 300
image = PhotoImage(file="/opt/myapp/MyApp/img/settings.png").zoom(10).subsample(32)
canvas = Canvas(frame, width=width, height=height, bg='white', bd=0, highlightthickness=0)
canvas.create_image(width/2,height/2, image=image)
canvas.grid(row=0, column=0, sticky=W)

#sous boite
right_frame = Frame(frame, bg='white')

#titre
label_title = Label(right_frame, text="Mot de passe", font=("Helvetica", 20), bg='white', fg='black')
label_title.pack()

#champ/input
password_entry = Entry(right_frame, font=("Helvetica", 20), bg='white', fg='black')
password_entry.pack(pady=5)

#bouton de génération
gen_button = Button(right_frame, text="Générer", font=("Helvetica", 20), bg='black', fg='white', command=generate_password)
gen_button.pack(pady=25, fill=X)

#cette frame est placee a droite de la frame principale
right_frame.grid(row=0, column=1, sticky=W)

#afficher frame
frame.pack(expand=YES)

#barre de menu
menu_bar = Menu(window,bg="black", fg='white')
file_menu = Menu(menu_bar, tearoff=0)
file_menu.add_command(label="Générer", command=generate_password)
file_menu.add_command(label="Quitter", command=window.quit)
menu_bar.add_cascade(label="Fichier", menu=file_menu)

window.config(menu=menu_bar)


window.mainloop()