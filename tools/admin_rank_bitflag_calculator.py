import tkinter as tk
from tkinter import ttk

bitflags = {
    "R_BUILDMODE": 1<<0,
    "R_ADMIN": 1<<1,
    "R_BAN": 1<<2,
    "R_FUN": 1<<3,
    "R_SERVER": 1<<4,
    "R_DEBUG": 1<<5,
    "R_POSSESS": 1<<6,
    "R_PERMISSIONS": 1<<7,
    "R_STEALTH": 1<<8,
    "R_REJUVINATE": 1<<9,
    "R_VAREDIT": 1<<10,
    "R_SOUNDS": 1<<11,
    "R_SPAWN": 1<<12,
    "R_MOD": 1<<13,
    "R_EVENT": 1<<14,
    "R_HOST": 1<<15,
    "-------------": 0,
    "EVERYTHING": (1<<16)-1
}

class BitflagCalculator:
    def __init__(self, master):
        self.master = master
        master.title("Bitflag Calculator")
        master.geometry("300x625")

        self.checkboxes = {}
        self.vars = {}

        for i, (flag, value) in enumerate(bitflags.items()):
            var = tk.IntVar()
            cb = ttk.Checkbutton(master, text=flag, variable=var, command=self.update_result)
            cb.grid(row=i, column=0, sticky="w", padx=10, pady=2)
            self.checkboxes[flag] = cb
            self.vars[flag] = var

        self.result_label = ttk.Label(master, text="Result: 0")
        self.result_label.grid(row=len(bitflags), column=0, pady=10)

        self.copy_button = ttk.Button(master, text="Copy Result", command=self.copy_result)
        self.copy_button.grid(row=len(bitflags)+1, column=0, pady=5)

        self.clear_button = ttk.Button(master, text="Clear All", command=self.clear_all)
        self.clear_button.grid(row=len(bitflags)+2, column=0, pady=5)

    def update_result(self):
        result = sum(value for flag, value in bitflags.items() if self.vars[flag].get())
        self.result_label.config(text=f"Result: {result}")

    def copy_result(self):
        result = sum(value for flag, value in bitflags.items() if self.vars[flag].get())
        self.master.clipboard_clear()
        self.master.clipboard_append(str(result))

    def clear_all(self):
        for var in self.vars.values():
            var.set(0)
        self.update_result()

root = tk.Tk()
calculator = BitflagCalculator(root)
root.mainloop()
