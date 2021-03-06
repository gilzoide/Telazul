extends "../Player.gd"

const Paint = preload("res://win98/paint.tscn")
const Bsod = preload("res://win98/bsod.tscn")
const Clippy = preload("res://win98/clippy.tscn")

export(int) var raio_clippy = 3

## Paint: só onde tem domínio (e nada lá)
func nao_tem_spawn_fora_bsod(idx):
	var spawn = Tabuleiro.get_spawn(idx)
	return spawn == null or spawn.has_meta("bsod")
func possibilidades_acao1(tabuleiro):
	return Utils.acha_dominio_do_jogador(self, tabuleiro, funcref(self, "nao_tem_spawn_fora_bsod"))
## Bsod: onde ninguém tem domínio
func possibilidades_acao2(tabuleiro):
	return Utils.acha_dominio_do_jogador(null, tabuleiro, funcref(self, "nao_tem_spawn"))
## Clippy: só onde tem processos inimigos
func eh_inimigo(idx):
	var spawn = Tabuleiro.get_spawn(idx)
	return spawn != null and not (nome in spawn.get_groups())
func possibilidades_acao3(tabuleiro):
	return Utils.acha_casas_no_raio(Tabuleiro.pos2idx(self.get_pos()), raio_clippy, funcref(self, "eh_inimigo"))

## Paint: 
func acao1(idx):
	Tabuleiro.mata_spawn(idx)  # Mata possíveis BSODs
	Tabuleiro.spawna_pro_jogador(self, Paint, idx)
## Bsod: 
func acao2(idx):
	Tabuleiro.spawna_pro_jogador(self, Bsod, idx)
## Clippy: 
func acao3(idx, cb):
	var c = Clippy.instance()
	c.setup(get_pos(), Tabuleiro.idx2pos(idx), idx, cb)
	Tabuleiro.add_child(c)