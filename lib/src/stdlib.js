range = function(start, end, step) {
    if (start > end) throw "ERROR: Range start bigger than end.";
    if ('undefined' === typeof step) step = 1;
    auxRange = function(num) { return num * step + start };
    return Array.apply(null, {length: Math.ceil((end - start)/step)}).
        map(Function.call, auxRange);
};

add = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            var aux = new Object();
            for(var key in auxA) aux[key] = auxA[key];
            for(var key in auxB) {
                if(aux.hasOwnProperty(key))
                    throw "ERROR: Objects have same key.";
                else {
                    aux[key] = auxB[key];
                }
            }
            return aux;
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be added.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be added.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be added.";
        } else {
            return auxB.add(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be added.";
        } else if(auxB.constructor === Array) {
            return auxA.concat(auxB);
        } else if(auxB.constructor === Number) {
            auxA.push(auxB);
            return auxA;
        } else if(auxB.constructor === String) {
            auxA.push(auxB);
            return auxA;
        } else {
            return auxB.add(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be added.";
        } else if(auxB.constructor === Array) {
            auxB.unshift(auxA);
            return auxB;
        } else if(auxB.constructor === Number) {
            return auxA + auxB;
        } else if(auxB.constructor === String) {
            return auxA + auxB;
        } else {
            auxB.unshift(auxA);
            return auxB;
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be added.";
        } else if(auxB.constructor === Array) {
            return auxB.unshift(auxA);
        } else if(auxB.constructor === Number) {
            return auxA + auxB;
        } else if(auxB.constructor === String) {
            return auxA + auxB;
        } else {
            return auxB.add(auxA);
        }
    } else {
        return auxA.add(auxA);
    }
};

sub = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            var aux = new Object();
            for(var key in auxA){
                if(!auxB.hasOwnProperty(key))
                    aux[key] = auxA[key];
            }
            return aux;
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be substracted.";
        } else {
            return auxB.sub(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be substracted.";
        } else {
            return auxB.sub(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Number) {
            return auxA - auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be substracted.";
        } else {
            return auxB.sub(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be substracted.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be substracted.";
        } else {
            return auxB.sub(auxA);
        }
    } else {
        return auxA.sub(auxB);
    }
};

prod = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be multiplied.";
        } else {
            return auxB.prod(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Number) {
            var aux = [];
            for(; auxB > 0; auxB--)
                aux.concat(auxA)
            return aux
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be multiplied.";
        } else {
            return auxB.prod(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Array) {
            var aux = [];
            for(; auxB > 0; auxA--)
                aux.concat(auxB)
            return aux
        } else if(auxB.constructor === Number) {
            console.log(auxA*auxB);
            return auxA * auxB;
        } else if(auxB.constructor === String) {
            aux = '';
            for(;auxA > 0; auxA--)
                aux += auxB;
            return aux;
        } else {
            return auxB.prod(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be multiplied.";
        } else if(auxB.constructor === Number) {
            aux = '';
            for(;auxB > 0; auxB--)
                aux += auxA;
            return aux;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be multiplied.";
        } else {
            return auxB.prod(auxA);
        }
    } else {
        return auxA.prod(auxB);
    }
};

div = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be divided.";
        } else {
            return auxB.div(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be divided.";
        } else {
            return auxB.div(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Number) {
            return auxA / auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be divided.";
        } else {
            return auxB.div(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types can not be divided.";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types can not be divided.";
        } else {
            return auxB.div(auxA);
        }
    } else {
        return auxA.div(auxB);
    }
};

mod = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else {
            return auxB.mod(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else {
            return auxB.mod(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Number) {
            return auxA % auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else {
            return auxB.mod(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation mod('%').";
        } else {
            return auxB.mod(auxA);
        }
    } else {
        return auxA.mod(auxB);
    }
};

pow = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else {
            return auxB.pow(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else {
            return auxB.pow(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Number) {
            return Math.pow(auxA,auxB);
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else {
            return auxB.pow(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation pow('**').";
        } else {
            return auxB.pow(auxA);
        }
    } else {
        return auxA.pow(auxB);
    }
};

shiftL = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else {
            return auxB.shiftL(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else {
            return auxB.shiftL(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Number) {
            return auxA << auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else {
            return auxB.shiftL(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftL('<<').";
        } else {
            return auxB.shiftL(auxA);
        }
    } else {
        return auxA.shiftL(auxB);
    }
};

shiftR = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else {
            return auxB.shiftR(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else {
            return auxB.shiftR(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Number) {
            return auxA >> auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else {
            return auxB.shiftR(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation shiftR('>>').";
        } else {
            return auxB.shiftR(auxA);
        }
    } else {
        return auxA.shiftR(auxB);
    }
};

xor = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else {
            return auxB.xor(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else {
            return auxB.xor(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Number) {
            return auxA ^ auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else {
            return auxB.xor(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation xor('^').";
        } else {
            return auxB.xor(auxA);
        }
    } else {
        return auxA.xor(auxB);
    }
};

bitwiseNot = function(auxA) {
    if(auxA.constructor !== Number)
        throw "ERROR: Operation bitwiseNot('~') only for Number";
    return ~auxA;
};


bitwiseAnd = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else {
            return auxB.bitwiseAnd(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else {
            return auxB.bitwiseAnd(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Number) {
            return auxA & auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else {
            return auxB.bitwiseAnd(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseAnd('&').";
        } else {
            return auxB.bitwiseAnd(auxA);
        }
    } else {
        return auxA.bitwiseAnd(auxB);
    }
};

bitwiseOr = function(auxA, auxB) {
    if(auxA.constructor === Object) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else {
            return auxB.bitwiseOr(auxA);
        }
    } else if(auxA.constructor === Array) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else {
            return auxB.bitwiseOr(auxA);
        }
    } else if(auxA.constructor === Number) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Number) {
            return auxA | auxB;
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else {
            return auxB.bitwiseOr(auxA);
        }
    } else if(auxA.constructor === String) {
        if(auxB.constructor === Object) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Array) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === Number) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else if(auxB.constructor === String) {
            throw "ERROR: Types do not soport operation bitwiseOr('|').";
        } else {
            return auxB.bitwiseOr(auxA);
        }
    } else {
        return auxA.bitwiseOr(auxB);
    }
};

negative = function(auxA) {
     if(auxA.constructor !== Number)
        throw "ERROR: Operation negative('-') only for Number";
    return -auxA;
};
