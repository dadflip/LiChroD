import os
import subprocess
import tkinter as tk
from tkinter import filedialog, messagebox
from tkinter.ttk import *
import pyttsx3
from playsound import playsound

def open_dashboard():
    try:
        engine = pyttsx3.init()
        engine.say('Welcome.')
        engine.say('on... My... App')
        engine.runAndWait()

        playsound('/opt/myapp/MyApp/sounds/cassette.wav')

        # Change the working directory and run the dashboard script
        os.chdir('/opt/myapp/MyApp/')
        subprocess.run(["python3", "dashboard.py"])
    except Exception as e:
        messagebox.showerror("Error", f"An error occurred: {e}")

class MyApp:
    def __init__(self):
        self.window = tk.Tk()
        self.window.title("My App")
        self.window.geometry("1080x720")
        self.window.minsize(480, 360)
        self.window.config(background='purple')

        self.create_widgets()
        self.window.mainloop()

    def create_widgets(self):
        frame = tk.Frame(self.window, bg='purple', bd=2, relief=tk.FLAT)

        label_title = tk.Label(frame, text="Bienvenue sur My App", font=("Arial", 40), bg='purple', fg='white')
        label_title.pack(expand=tk.YES)

        label_subtitle = tk.Label(frame, text="Votre logiciel de gestion Linux !", font=("Arial", 25), bg='purple', fg='white')
        label_subtitle.pack(expand=tk.YES)

        start_button = tk.Button(frame, text='Allons y', font=("Arial", 20), bg='red', fg='white', command=open_dashboard)
        start_button.pack(pady=25, fill=tk.X)

        frame.pack(expand=tk.YES)

if __name__ == '__main__':
    app = MyApp()
