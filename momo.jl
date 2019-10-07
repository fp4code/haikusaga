"""
    nll,nllc = rd_dico()
Retourne nll la liste des bons mots, et nllc la liste des mots rejetés
"""
function rd_dico()
    ll = Array{String,1}()
    # https://infolingu.univ-mlv.fr/DonneesLinguistiques/Dictionnaires/telechargement.html
    f = open("dela-fr-public.dic",enc"UTF-16LE","r")
    for l in eachline(f)
        push!(ll, l)
    end
    close(f)
    nll = Array{String,1}()
    nllc = Array{String,1}()
    function mot(l)
        i = findfirst(",",l)[1]
        nl = l[1:prevind(l, i, 1)]
    end
    for l in ll
    	nl = mot(l)
   	if isnothing(findfirst(" ",nl)) && isnothing(findfirst("-",nl))
            push!(nll, nl)
        else
            push!(nllc, nl)
        end
    end
    (nll,nllc)
end

nll,nllc = rd_dico()


"""
    setoflettres(nll)
Retourne l'ensemble des lettres utilisées dans les mots de la liste nll
"""
function setoflettres(nll)
    lettres = Set{Char}()  
    for l in nll
        for c in l
            push!(lettres, c)
        end
    end
    lettres
end


"""
    dico,sol = dicoflower(sl)
Retourne le dictionnaire dico lettre -> lettre minuscule
et l'ensemble des lettres minuscules
"""
function dicoflower(sl)
    dico = Dict{Char,Char}()
    sol = Set{Char}()
    for c in sl
        cl = lowercase(c)
        dico[c] = cl
        push!(sol, cl)
    end
    dico,sol
end

sl = setoflettres(nll)
sll,sol = dicoflower(sl)


"""
Dictionnaire des lettres accentuées
"""
dicos = Dict{Char,Union{Char,Missing}}()
dicos['\''] = '\'';
dicos['-'] = missing;
dicos['0'] = missing;
dicos['1'] = missing;
dicos['\\'] = missing;
dicos['a'] = 'a';
dicos['b'] = 'b';
dicos['c'] = 'c';
dicos['d'] = 'd';
dicos['e'] = 'e';
dicos['f'] = 'f';
dicos['g'] = 'g';
dicos['h'] = 'h';
dicos['i'] = 'i';
dicos['j'] = 'j';
dicos['k'] = 'k';
dicos['l'] = 'l';
dicos['m'] = 'm';
dicos['n'] = 'n';
dicos['o'] = 'o';
dicos['p'] = 'p';
dicos['q'] = 'q';
dicos['r'] = 'r';
dicos['s'] = 's';
dicos['t'] = 't';
dicos['u'] = 'u';
dicos['v'] = 'v';
dicos['w'] = 'w';
dicos['x'] = 'x';
dicos['y'] = 'y';
dicos['z'] = 'z';
dicos['à'] = 'a';
dicos['â'] = 'a';
dicos['ã'] = 'a';
dicos['ä'] = 'a';
dicos['ç'] = 'c';
dicos['è'] = 'e';
dicos['é'] = 'e';
dicos['ê'] = 'e';
dicos['ë'] = 'e';
dicos['î'] = 'i';
dicos['ï'] = 'i';
dicos['ñ'] = 'n';
dicos['ó'] = 'o';
dicos['ô'] = 'o';
dicos['õ'] = 'o';
dicos['ö'] = 'o';
dicos['ù'] = 'u';
dicos['û'] = 'u';
dicos['ü'] = 'u';
dicos['﻿'] = missing;

"""
Dictionnaire Letre quelconque -> minuscule non accentuée
"""
DICASCII = Dict{Char,Union{Char,Missing}}()
for k in sll
    DICASCII[k[1]] = dicos[k[2]]
end

arrg = Array{Array{UInt8,1},1}()
setg = Set{String}()

for m in nll
    nm = Array{UInt8,1}(undef,length(m))
    nsm = ""
    i = 0
    ok = true
    for c in m
        i += 1
        ca = DICASCII[c]
        if ismissing(ca)
            println(m)
            ok = false
            continue
        else
            nm[i] = ca
            nsm *= ca
        end
    end
    if ok
        if !(nsm in setg)
            push!(arrg, nm)
        end
        push!(setg, nsm)
    end
end

"""
a = Array{UInt8,1}(['a','b','c'])
length(a)     # 3
s = String(a) # "abc"
length(a)     # 0 Bug or feature ? feature Cf. doc.
"""

myString(a) = String(copy(a))

# voir le pb. de prudh'homme

myString(arrg[312157])

struct Momo
    c::UInt8
    t::Array{Momo,1}
end

function pushtomomo!(momo::Momo, m::Array{UInt8,1})
    if length(m) == 0
        push!(momo.t, Momo(0x00, []))
        return
    end
    c = m[1]
    found = false
    for mt in momo.t
        if c == mt.c
            pushtomomo!(mt, m[2:end])
            found = true
            break
        end
    end
    if !found
        nmomo = Momo(c, [])
        pushtomomo!(nmomo, m[2:end])
        push!(momo.t, nmomo)
    end
end

function buildmomo()
    alpha = Momo(0x00, [])
    for m in arrg
        pushtomomo!(alpha, m)
    end
    alpha
end

function findc(momo::Momo, c::UInt8)
    for nm in momo.t
        if nm.c == c
            return nm
        end
    end
    nothing
end


function findm(momo::Momo, m::Array{UInt8,1})
    if length(m) == 0
        return momo
    end
    nm = findc(momo, m[1])
    if nm == 0x00
        return nothing
    end
    return findm(nm, m[2:end])
end

function explore(out::String, momo::Momo, c::UInt8)
    nm = findc(momo, c)
    if !isnothing(nm)
        return out*Char(nm.c),nm
    else
        return out,nm
    end
end

# Facilités
findc(momo::Momo, c::Char) = findc(momo, UInt8(DICASCII[c]))
