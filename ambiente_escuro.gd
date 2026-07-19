extends CanvasModulate

@export var escuro_total: Color = Color("000000")
@export var luz_do_dia: Color = Color("ffffff")

func definir_escuridao(deve_ficar_escuro: bool):
	if deve_ficar_escuro:
		color = escuro_total
	else:
		color = luz_do_dia
