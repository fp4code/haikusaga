import Pkg; Pkg.activate("env")

using StringEncodings

include("momo.jl")
include("h.jl")
include("control.jl")


USAGE = """
unzip dela-fr-public.zip # il y a des personnes louches dedans

import Pkg; Pkg.activate("env")
Pkg.add("StringEncodings")

include("haikusaga.jl")
haikusaga("aimer fait mal") #HS0201
haikusaga("plus que hair") #HS0202
s = "Liure au pieu ?
Quelque ruse salique ?
Perles à la paupière ?
Sus, rue, résilie, Lili !"
control("plus que hair", s)
"""

"""
Un Momo a est un structure qui contient tous les mots débutant par a.c
Ces mots sont une liste a.t de momos

BIGMOMO est le Momo de tous les Momo's
Il part de rien

julia BIGMOMO.c == 0x00

julia> length(BIGMOMO.t) # 26
parce qu'il y a 26 lettres possibles pour commence un mot

julia> a = BIGMOMO.t[1];
julia> a.c # 0x61
julia> Char(a.c) # 'a'
Le premier mot commence par la lettre 'a' (c'est du hasard, pas de tri)

julia> length(a.t) # 27
Tiens, une lettre de trop ?
julia> sort(map(x -> Char(x.c), a.t)) # '\0' 'a' ...
Non, le caractère 0x00 est accepté, il signifie que le mot est terminé.
C'est à dire que "a" est un mot.
"""
BIGMOMO = buildmomo()


"""
BIGMOMO est le Momo qui commence par n'importe quoi.
Il n'y a pas de mot vide
julia> nm = findc(BIGMOMO, 0x00);
julia> @assert isnothing(nm)
"""

"""
Mais il y a le mot "l"
julia> nm = findc(BIGMOMO, UInt8('l'));
julia> nm0 = findc(nm, 0x00)
julia> @assert !isnothing(nm0)

julia> z = findc(BIGMOMO, 'z');
julia> @assert z.c == UInt8('z')
julia> length(z.t) # 10
julia> zi = findc(z, 'i');
julia> length(zi.t) # 11
julia> zip = findc(zi, 'p');
julia> sort(map(x -> Char(x.c), zip.t)) # '\0' 'p' 's'
Donc "zip" existe puisqu'il peut se terminer par '\0'
Il y a aussi "zipp..." et "zips..."
julia> zips = findc(zip, 's') # Momo(0x73, Momo[Momo(0x00, Momo[])])
En fait "zips" est le seul "zips..." 

La fonction explore retoure la chaine donnée complétée avec le caractère donné
et le Momo des mots qui poursuivent le Momo donné avec le caractère donné
julia> zips = explore("devrait_etre_zip_", zip, UInt8('s'))

"""

