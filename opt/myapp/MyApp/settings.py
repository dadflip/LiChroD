from tkinter import *
from tkinter import ttk
from tkinter import font

class Parametres(Toplevel):
    def __init__(self, parent):
        Toplevel.__init__(self, parent)
        self.transient(parent)
        self.title("Paramètres")

        # Taille et position
        self.geometry("+%d+%d" % (parent.winfo_rootx()+50,
                                  parent.winfo_rooty()+50))

        # Variables des paramètres
        self.theme_var = StringVar(value='light')
        self.font_size_var = IntVar(value=12)
        self.font_family_var = StringVar(value='Helvetica')

        # Création des widgets
        self.creer_theme()
        self.creer_police()

        # Boutons OK et Annuler
        boutons_frame = Frame(self)
        boutons_frame.pack(side=BOTTOM, pady=10)

        ok_button = Button(boutons_frame, text="OK", command=self.ok)
        ok_button.pack(side=LEFT, padx=5)

        annuler_button = Button(boutons_frame, text="Annuler",
                                command=self.destroy)
        annuler_button.pack(side=LEFT, padx=5)

    def creer_theme(self):
        frame_theme = LabelFrame(self, text="Thème")
        frame_theme.pack(side=TOP, padx=10, pady=10)

        themes = {"Light": "light", "Dark": "dark", "Blue": "blue"}
        for theme, value in themes.items():
            Radiobutton(frame_theme, text=theme, variable=self.theme_var,
                        value=value).pack(anchor=W)

    def creer_police(self):
        frame_police = LabelFrame(self, text="Police")
        frame_police.pack(side=TOP, padx=10, pady=10)

        label_taille = Label(frame_police, text="Taille:")
        label_taille.grid(row=0, column=0, padx=5, pady=5)

        taille_liste = [8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 28, 32, 36,
                        40, 44, 48, 54, 60, 66, 72, 80, 88, 96]
        taille_combobox = ttk.Combobox(frame_police, values=taille_liste,
                                       textvariable=self.font_size_var)
        taille_combobox.grid(row=0, column=1, padx=5, pady=5)

        label_famille = Label(frame_police, text="Famille:")
        label_famille.grid(row=1, column=0, padx=5, pady=5)

        famille_liste = list(font.families())
        famille_combobox = ttk.Combobox(frame_police, values=famille_liste,
                                         textvariable=self.font_family_var)
        famille_combobox.grid(row=1, column=1, padx=5, pady=5)

    def ok(self):
        print("Thème:", self.theme_var.get())
        print("Taille de police:", self.font_size_var.get())
        print("Famille de police:", self.font_family_var.get())
        self.destroy()
