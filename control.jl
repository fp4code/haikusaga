
for c in [',', ' ', ':', '.', '!', '?', '\n', '\'', '’']
    DICASCII[c] = missing
end
DICASCII['É'] = 'e';
DICASCII['Â'] = 'a';
DICASCII['À'] = 'a';

function nettoie(s)
    sn = Array{UInt8, 1}()
    for c in s
        cn = DICASCII[c]
        if !ismissing(cn)
            push!(sn, cn)
        end
    end
    sn
end

function control(AMOTS, lir, sn)
    if length(sn) == 0
        # println(lir)
	return (true, lir)
    end
    for i in 1:length(AMOTS)
        if length(lir) > 0 && i == lir[end]
	    continue
	end
        if sn[1] in AMOTS[i]
            nlir = [lir; i]
	    ret = control(AMOTS, nlir, sn[2:end])
	    if ret[1]
	        return ret 
            end
        end
    end
    return false
end


control(AMOTS, sn) = control(AMOTS, Array{UInt8, 1}(), sn)
