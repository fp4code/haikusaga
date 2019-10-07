
"""
COnstruit la liste reponses
Explore dans momo (typiquement BIGMOMO) les mots qui commencent par out
et dont la lettre suivante ne fait pas partie du ii ème mot de la liste AMOTS

"""
function explore_2(amots, reponses, out, momo, ii0, ii)
    for i in 1:length(amots)
        if i == ii
            continue
        end
    	istart = ii0 == 0 ? i : ii0
        for c in amots[i]
            nout, nm = explore(out, momo, c)
            if isnothing(nm)
                continue
            end
            if !isnothing(findc(nm, 0x00))
	        push!(reponses, (nout, istart, i))
            end
            explore_2(amots, reponses, nout, nm, istart, i)
        end
    end
end

explore_2(amots, reponses, ii0, i) = explore_2(amots, reponses, "", BIGMOMO, ii0, i)


function liste_mots(mots)
    amots = Array{Array{UInt8,1},1}()
    for m in split(mots, ' ')
        s = Set{UInt8}()
        for c in m
            push!(s, UInt8(c))
        end
        push!(amots, sort!(collect(s)))
    end
    amots
end

function sizeforword(lili)
    lw = 0
    for mot in lili
        lm = length(mot)
        if lm > lw
            lw = lm
        end
    end
    lw
end

function haikusaga(s)
    AMOTS = liste_mots(s)
    REPONS = Array{Tuple{String,Int8,Int8}, 1}()
    explore_2(AMOTS, REPONS, 0, 0)

    dicom = Dict{String, Array{Tuple{Int8,Int8},1}}()
    for (s,i1,i2) in REPONS
        if haskey(dicom, s)
            if !((i1,i2) in dicom[s])
                push!(dicom[s], (i1,i2))
	    end
        else
            dicom[s] = [(i1,i2)]
        end
    end

    lw = sizeforword(keys(dicom))

    for mot in sort(collect(keys(dicom)))
        print(rpad(mot, lw))
        first = true
        for v in sort(dicom[mot])
            print(' ',v[1],v[2])
        end
        println()
    end
end

