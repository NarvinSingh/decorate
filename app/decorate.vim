let s:debug = 0

function! decorate#DecorateLine(...)

    " Parameters {{{
    let a:comm          = get(a:000, 0, '"')
    let a:decLeft       = get(a:000, 1, '~')
    let a:decRight      = get(a:000,
                        \   2,
                        \   join(reverse(split(a:decLeft, '\zs')), ''))
    let a:padLeft       = get(a:000, 3, 1)
    let a:padRight      = get(a:000, 4, a:padLeft)
    let a:endComm       = get(a:000, 5, 1)
    " }}}

    " Variables {{{
    let hdrLen          = virtcol('$') - 1
    let lineLen         = &colorcolumn !=# "" ? &colorcolumn - 1 : 80
    let commLeftLen     = strlen(a:comm)
    let commRightLen    = (a:endComm ? commLeftLen : 0)
    let maxHdrLen       = lineLen
    let maxHdrLen       -= a:padLeft
    let maxHdrLen       -= a:padRight
    let maxHdrLen       -= commLeftLen
    let maxHdrLen       -= commRightLen
    " }}}

    " Short circuit return if header is too long to decorate {{{
    if hdrLen > maxHdrLen
        echom 'DecorateHeader: Header is too long to decorate.'

        return
    endif
    " }}}

    " More variables {{{
    let decLeftLen      = strlen(a:decLeft)
    let byteLeftLen     = ((lineLen + 1) / 2)   " First two lines of expression
    let byteLeftLen     -= ((hdrLen + 1) / 2)   " not simplified to take
    let byteLeftLen     -= a:padLeft            " advantage of integer division
    let byteLeftLen     -= commLeftLen          " truncation
    let bdrLeftLen      = byteLeftLen / decLeftLen
    let bdrLeftMod      = byteLeftLen % decLeftLen
    let bdrLeftXtra     = bdrLeftMod > 0 ? a:decLeft[-bdrLeftMod:] : ''
    let decRightLen     = strlen(a:decRight)
    let byteRightLen    = (lineLen / 2)         " First two lines of expression
    let byteRightLen    -= (hdrLen / 2)         " not simplified to take
    let byteRightLen    -= a:padRight           " advantage of integer division
    let byteRightLen    -= commRightLen         " truncation
    let bdrRightLen     = byteRightLen / decRightLen
    let bdrRightMod     = byteRightLen % decRightLen
    let bdrRightXtra    = bdrRightMod > 0 ? a:decRight[0:bdrRightMod - 1] : ''
    " }}}

    " The command {{{
    let cmd             = 'normal! A'
    let cmd             .= repeat(' ', a:padRight)
    let cmd             .= repeat(a:decRight, bdrRightLen)
    let cmd             .= bdrRightXtra
    let cmd             .= (a:endComm ? a:comm : '')
    let cmd             .= "\<ESC>0i"
    let cmd             .= a:comm
    let cmd             .= bdrLeftXtra
    let cmd             .= repeat(a:decLeft, bdrLeftLen)
    let cmd             .= repeat(' ', a:padLeft)
    let cmd             .= "\<ESC>\<CR>"
    " }}}

    " Print parameters and variables for debugging {{{
    if s:debug
        echom 'DecorateHeader'
        echom '=====================' . '======'
        echom '    Variable         ' . 'Value'
        echom '    -----------------' . '------'
        echom '    comm.............' . a:comm
        echom '    decLeft..........' . a:decLeft
        echom '    decRight.........' . a:decRight
        echom '    padLeft..........' . a:padLeft
        echom '    padRight.........' . a:padRight
        echom '    endComm..........' . a:endComm
        echom '    hdrLen...........' . hdrLen
        echom '    lineLen..........' . lineLen
        echom '    commLeftLen......' . commLeftLen
        echom '    commRightLen.....' . commRightLen
        echom '    maxHdrLen........' . maxHdrLen
        echom '    decLeftLen.......' . decLeftLen
        echom '    byteLeftLen......' . byteLeftLen
        echom '    bdrLeftLen.......' . bdrLeftLen
        echom '    bdrLeftMod.......' . bdrLeftMod
        echom '    bdrLeftXtra......' . bdrLeftXtra
        echom '    decRightLen......' . decRightLen
        echom '    byteRightLen.....' . byteRightLen
        echom '    bdrRightLen......' . bdrRightLen
        echom '    bdrRightMod......' . bdrRightMod
        echom '    bdrRightXtra.....' . bdrRightXtra
        echom '    cmd..............' . cmd
        echom ''
    endif
    " }}}

    execute cmd
endfunction
