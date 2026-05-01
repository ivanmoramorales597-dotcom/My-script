import tkinter as tk
from tkinter import messagebox
import threading
import time
import requests

API_URL = "https://api.stealabrainrot.com/brainrots"  # URL ejemplo, reemplazar con la real

class AutoJoinerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Auto Joiner Brainrot")
        self.min_valor = tk.IntVar(value=100_000_000)
        self.spam_active = False
        self.current_server = None

        # Configuración UI
        tk.Label(root, text="Valor mínimo brainrot:").grid(row=0, column=0, sticky="w")
        tk.Entry(root, textvariable=self.min_valor).grid(row=0, column=1)

        self.listbox = tk.Listbox(root, width=50)
        self.listbox.grid(row=1, column=0, columnspan=2, pady=10)
        self.listbox.bind('<<ListboxSelect>>', self.on_select)

        btn_join = tk.Button(root, text="JOIN", command=self.join_server)
        btn_join.grid(row=2, column=0, sticky="ew")

        self.btn_force = tk.Button(root, text="FORCE ON", command=self.toggle_spam)
        self.btn_force.grid(row=2, column=1, sticky="ew")

        self.status = tk.Label(root, text="Estado: Esperando", fg="blue")
        self.status.grid(row=3, column=0, columnspan=2)

        self.brainrots = []
        self.update_brainrots()

    def update_brainrots(self):
        try:
            response = requests.get(API_URL)
            data = response.json()
            self.brainrots = [b for b in data if b['valor'] >= self.min_valor.get()]
            self.listbox.delete(0, tk.END)
            for b in self.brainrots:
                self.listbox.insert(tk.END, f"{b['id']} - {b['servidor']} - ${b['valor']}")
            self.status.config(text=f"Estado: {len(self.brainrots)} brainrots encontrados")
        except Exception as e:
            self.status.config(text=f"Error al obtener brainrots: {e}", fg="red")
        self.root.after(10000, self.update_brainrots)  # Actualiza cada 10 segundos

    def on_select(self, event):
        selection = self.listbox.curselection()
        if selection:
            index = selection[0]
            self.current_server = self.brainrots[index]['servidor']
            self.status.config(text=f"Seleccionado servidor: {self.current_server}")

    def join_server(self):
        if self.current_server:
            self.status.config(text=f"Uniéndose al servidor {self.current_server}...")
            # Aquí iría la lógica para unirse al servidor
            messagebox.showinfo("JOIN", f"Unido al servidor {self.current_server}")
        else:
            messagebox.showwarning("JOIN", "Selecciona un servidor primero.")

    def toggle_spam(self):
        if not self.current_server:
            messagebox.showwarning("SPAM", "Selecciona un servidor primero.")
            return
        self.spam_active = not self.spam_active
        if self.spam_active:
            self.btn_force.config(text="FORCE OFF")
            self.status.config(text=f"Spam activado en {self.current_server}")
            threading.Thread(target=self.spam_server, daemon=True).start()
        else:
            self.btn_force.config(text="FORCE ON")
            self.status.config(text=f"Spam desactivado")

    def spam_server(self):
        while self.spam_active:
            # Aquí iría la lógica para enviar mensajes spam al servidor
            print(f"Spam en {self.current_server}...")
            time.sleep(1)

if __name__ == "__main__":
    root = tk.Tk()
    app = AutoJoinerApp(root)
    root.mainloop()
