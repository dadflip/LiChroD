from math import *
from random import *
from statistics import *

import tkinter
from tkinter import *
from tkinter import Tk, ttk, messagebox,filedialog
from tkinter.messagebox import *
from tkinter.filedialog import *

from subprocess import *
import os

from pyttsx3.engine import *
from playsound import *

from app import open_dashboard



#################################### FONCTIONS ###########################################################
# Import the dashboard.py module to access the open_dashboard function
#from dashboard import open_dashboard

class TableDropDown(ttk.Combobox):

    def __init__(self, parent):
        ttk.Combobox.__init__(self, parent)
        
        self.current_table = tkinter.StringVar()  # create variable for table
        self.config(values=["Table1", "Table2", "Table3"]) # set values for drop down box 
        self.current(0) # index of values for current table
        self.bind('<<ComboboxSelected>>', self.update_table)  # bind selection event
        self.pack(side='left', padx=10, pady=10)  # use pack geometry manager instead of place

    def update_table(self, event):
        selected_table = self.get()
        print(f"Selected table is {selected_table}")
        # Call the open_dashboard method of dashboard module
        open_dashboard(selected_table)


# function to handle error message box and sound
def show_error(message):
    playsound('/opt/myapp/MyApp/sounds/cassette.wav')
    messagebox.showerror("Erreur!", message)

# function to handle command execution through terminal
def execute_command(command):
    os.system(f'terminator -e "{command}"')
    
def main_action(option_dict, combo_box):
    selected_option = combo_box.get()
    if selected_option in option_dict:
        option_dict[selected_option]()
    else:
        print("Option not found!")


sys_options = {
    "Générateur Mot de Passe": lambda: call(["python3", "password_generator.py"]),
    "Gestion Mises à jour": lambda: call(["python3", "updates.py"]),
    "Flatpaks": lambda: execute_command('lichrod-flatpak-wizard.sh'),
    "Hashtag (hashed types finder)": lambda: hashtag_func(),
    "Hashcat (crack hashed passwords)": lambda: execute_command('lichrod-hashcat-launcher.sh'),
    "Apt (packages)": lambda: execute_command('lichrod-aptitude-wizard.sh')
}

web_options = {
    "PhpMyAdmin": lambda: execute_command('lichrod-phpmyadmin-opener.sh'),
    "Crowdsec": lambda: execute_command('sudo apt install -y sl && sl'),
    "Nikto Scan": lambda: execute_command('sudo apt install -y sl && sl'),
    "MariaDB (Mysql)": lambda: os.system('xterm -e sudo mariadb'),
    "ZAP (/!\\ server attack)": lambda: os.system('zap.sh')
}

def main_action(option_dict, combo_box):
    selected_option = combo_box.get()
    if selected_option in option_dict:
        option_dict[selected_option]()
    else:
        print("Option not found!")

# define a function to clear the comboboxes and update the interface
def clear_comboboxes():
    cmb_web.set("")    # Clear web combobox selection
    cmb_sys.set("")    # Clear sys combobox selection
    cmb_games.set("")  # Clear games combobox selection


# handle button click event
def checkcmbo():
    web_selected = cmb_web.get()
    sys_selected = cmb_sys.get()
    game_selected = cmb_games.get()

    # check if multiple options are selected
    if bool(web_selected) + bool(sys_selected) + bool(game_selected) > 1:
        show_error("Veuillez sélectionner UNE SEULE option")
        return
    
    # handle system options
    if sys_selected:
        sys_option_func = sys_options.get(sys_selected)
        if not sys_option_func:
            show_error("Veuillez sélectionner une option valide")
            return
        sys_option_func()

    # handle web options
    elif web_selected:
        web_option_func = web_options.get(web_selected)
        if not web_option_func:
            show_error("Veuillez sélectionner une option valide")
            return
        web_option_func()

    # handle game options
    elif game_selected:
        game_option_func = game_options.get(game_selected)
        if not game_option_func:
            show_error("Veuillez sélectionner une option valide")
            return
        game_option_func()

    # show error message if no option is selected
    else:
        show_error("Veuillez sélectionner une option")

    # Clear combobox selections after an option is selected
    clear_comboboxes()
    
def callback():
    if messagebox.askyesno('Titre 1', 'Êtes-vous sûr de vouloir faire ça?'):
        messagebox.showwarning('Titre 2', 'Tant pis...')
        showinfo()
        showwarning()
        messagebox.showerror()
        askquestion()
        askokcancel()
        askyesno()
        askretrycancel()
    else:
        showinfo('Titre 3', 'Vous avez peur!')
        showerror("Titre 4", "Aha")

def alert():
    showinfo("alerte", "Bravo!")



    

def open_terminal():
    os.system('terminator')


#Ouvrir documents
def open_document():
    playsound('/opt/myapp/MyApp/sounds/menu.wav')
    os.system(f'/bin/python3 /opt/myapp/MyApp/fileread.py')

def hashtag_func():
    filename = str(askopenfilename(title="Ouvrir votre document",filetypes=[('txt files','.txt'),('all files','.*')]))
    fichier = open(filename, "r")
    #content = fichier.read()
    cmd = 'xterm -e HashTag.py -f {} -o /opt/myapp/MyApp/extensions/HashTag/hashed_file.txt'.format(filename)
    os.system(cmd)
    fichier.close()
    showinfo("alerte", "Le fichier hashé se trouve dans le répertoire /opt/myapp/MyApp/extensions/HashTag/hashed_file.txt sous le nom (hashed_file.txt)")


def open_image():
    playsound('/opt/myapp/MyApp/sounds/menu.wav')
    os.system(f'/bin/python3 /opt/myapp/MyApp/test2.py')

#parametres/systeme
def preferences():
    execute_command('sudo nano /opt/myapp/MyApp/dashboard.py')

def systemctl():
    execute_command('sudo systemctl')

def update_all():
    execute_command('lichrod-update.sh')

def alert():
    showinfo("alerte", "Bravo!")

def create_file():
    execute_command('nano')

def refresh_networking():
    playsound('/opt/myapp/MyApp/sounds/menu.wav')
    os.system('sudo systemctl restart networking')
    playsound('/opt/myapp/MyApp/sounds/note.wav')
    showinfo("alerte", "Connexion rafraîchie !")

def addon_install():
    os.system('/usr/bin/myapp-extension-installer')
    

###
###AJOUTEZ VOS FONCTIONS ICI
###


##########################################ELEMENTS############################################################
#creation fenetre
window = Tk()

#personnalisation fenetre
window.title("My App - Dashboard")      #L'intitulé de votre Application
window.geometry("1080x720")             #Les dimensions de la fenêtre au démarrage
window.update()
wind_width=window.winfo_width()
wind_height=window.winfo_height()

print(wind_height,wind_width)
window.minsize(480, 360)                #La taille mini que peut avoir la fenêtre
window.config(background='purple')       #Indiquer une couleur pour le fond

#Mettre une image de fond:
#filename = PhotoImage(file = "dashboard1.png")  
#background_label = Label(window, image=filename)
#background_label.place(x=0, y=0, relwidth=1, relheight=1)


# create the menu bar and its cascades
menubar = Menu(window, bg="black", fg='white')

def apps_script_cascade():
    cascade_menu = Menu(menubar, tearoff=0)

    # Traverse /usr/bin and add files starting with "APP_" or "SCRIPT_"
    for filename in os.listdir("/usr/bin"):
        if filename.startswith(("APP_", "SCRIPT_")):
            label = filename.replace("_", " ").title()
            command = f"/usr/bin/{filename}"
            cascade_menu.add_command(label=label, command=lambda cmd=command: os.system(cmd))

    return cascade_menu


# create a list of cascade dictionaries
cascades = [
    {
        "name": "Fichier",
        "options": [
            {"label": "Ouvrir", "command": open_document},
            {"label": "Créer", "command": create_file},
            {"label": "Editer", "command": alert},
            {"type":"separator"},
            {"label":"Ouvrir terminal","command":open_terminal},
            {"label":"Quitter","command":window.quit}
        ]
    },
    {
        "name": "Editer",
        "options": [
            {"label": "Couper", "command": alert},
            {"label": "Copier", "command": alert},
            {"label": "Coller", "command": alert},
            {"type":"separator"},
            {"label":"Preferences","command":preferences},
        ]
    },
    {
        "name": "Commandes",
        "options": [
            {"label": "Systeme Control", "command": systemctl},
            {"label": "Tout mettre à jour", "command": update_all},
        ]
    },
    {
        "name": "Aide",
        "options": [
            {"label": "A propos", "command": alert},
        ]
    },
    {
        "name": "Apps/Script",
        "options": [apps_script_cascade()]
    }
]


for cascade in cascades:
    cascade_menu = Menu(menubar, tearoff=0)
    for option in cascade["options"]:
        if isinstance(option, Menu):
            cascade_menu.add_cascade(label=cascade["name"], menu=option)
        elif ("type" in option) and (option["type"] == "separator"):
            cascade_menu.add_separator()
        else:
            cascade_menu.add_command(label=option["label"], command=option["command"])

    menubar.add_cascade(label=cascade["name"], menu=cascade_menu)

# Configure the window with the created menu bar
window.config(menu=menubar)


Frame1 = LabelFrame(window, text="Actions Rapides", borderwidth=2, relief=GROOVE, bg="purple")
Button(Frame1, text='Action', bg="violet", command=callback).pack(side='left')
Button(Frame1, text='Ouvrir...', bg="violet", command=open_document).pack(side='right')
Button(Frame1, text='Image...', bg="violet", command=open_image).pack(side='right')
Frame1.pack(padx=5, pady=5, side=TOP)





l = LabelFrame(window, text="Dashboard", padx=30, pady=20, bg='white')
# System ComboBox
Label(l, text="System", font=("ComicSans", 20), bg='white', fg='black').pack(pady=10)
cmb_sys = ttk.Combobox(l, width="40", values=list(sys_options.keys()))
cmb_sys.pack()

# Web ComboBox
Label(l, text="Web", font=("ComicSans", 20), bg='white', fg='black').pack(pady=20)
cmb_web = ttk.Combobox(l, width="40", values=list(web_options.keys()))
cmb_web.pack()


# Action buttons
f = Frame(l, padx=30, pady=20, bg='white')
Button(f, text="Addon Installer", font=("ComicSans", 10), bg='black', fg='white', command=addon_install).pack(side="left")
Button(f, text="Connexion", font=("ComicSans", 10), bg='lightblue', fg='black', command=refresh_networking).pack(side='right')
Button(f, text="Execute", font=("ComicSans", 10), bg='green', fg='white', command=lambda: main_action(sys_options, cmb_sys) or main_action(web_options, cmb_web)).pack(side='right')
f.pack()
l.pack(fill="both", expand="yes", side=BOTTOM)





Frame3 = LabelFrame(window, text="Numpad", borderwidth=2, relief=GROOVE, bg="purple")

#Frame 4
frame4 = Frame(Frame3, bg="purple", padx=5, pady=5)
frame4.pack(side=BOTTOM)

#Clavier numerique
def add_to_display(value):
    display_var.set(display_var.get() + value)

def clear_display():
    display_var.set("")

display_var = StringVar()

num_pad = "1234567890"
for index, value in enumerate(num_pad):
    button = Button(frame4, text=value, width=3, height=2, command=lambda v=value: add_to_display(v))
    button.grid(row=index//3, column=index%3)

clear_button = Button(frame4, text='Clear', width=3, height=2, command=clear_display)
clear_button.grid(row=3, column=0,columnspan=3)

enter_button = Button(frame4, text='Enter', width=3, height=2, command=clear_display)
enter_button.grid(row=3, column=2,columnspan=6)

display_entry = Entry(Frame3, textvariable=display_var, width=20)
display_entry.pack(side=TOP)

Frame3.pack(padx=5, pady=5, side=LEFT)


#affichage
window.mainloop()



