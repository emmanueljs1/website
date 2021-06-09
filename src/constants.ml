open Program

let x_min = 0
let y_min = 60
let dist_delta = 5
let (font, font_size, font_color) = PressStart, 9, Hex "595959"

let reverse_bang = {j|¡|j}
let reverse_ask = {j|¿|j}
let accent_a = {j|á|j}
let knight_text_en = {j|Good morrow, traveler! Have thou heard of Emmanuel Su$(accent_a)rez? Hails he from the far land of Puerto Rico, legend says|j}
let knight_text_es = {j|$(reverse_bang)Saludos, aventurero! $(reverse_ask)Ha escuchado de Emmanuel Su$(accent_a)rez? Las leyendas dicen que viene de la tierra lejana de Puerto Rico|j}
