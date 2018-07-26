let s:debug = 0

function! decorate#DecorateLine(...)

    " Parameters {{{
    let a:commLeft      = get(a:000, 0, '"')
    let a:decLeft       = a:0 < 2 || a:2 !=# '' ? get(a:000, 1, ' ') : ' '
    let a:padLeft       = get(a:000, 2, 1)
    let a:padRight      = get(a:000, 3, a:padLeft)
    let a:decRight      = a:0 < 5 || a:5 !=# '' ?
                        \   get(
                        \       a:000,
                        \       4,
                        \       join(reverse(split(a:decLeft, '\zs')), '')) :
                        \   join(reverse(split(a:decLeft, '\zs')), '')
    let a:commRight     = get(a:000, 5, '')
    let a:lineLen       = get(a:000, 6, &colorcolumn !=# '' ? &colorcolumn : 80)
    " }}}

    " Variables {{{
    let hdrLen          = virtcol('$') - 1
    let commLeftLen     = strlen(a:commLeft)
    let commRightLen    = strlen(a:commRight)
    let maxHdrLen       = a:lineLen
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
    let byteLeftLen     = ((a:lineLen + 1) / 2) " First two lines of expression
    let byteLeftLen     -= ((hdrLen + 1) / 2)   " not simplified to take
    let byteLeftLen     -= a:padLeft            " advantage of integer division
    let byteLeftLen     -= commLeftLen          " truncation
    let bdrLeftLen      = byteLeftLen / decLeftLen
    let bdrLeftMod      = byteLeftLen % decLeftLen
    let bdrLeftXtra     = bdrLeftMod > 0 ? a:decLeft[-bdrLeftMod:] : ''
    let decRightLen     = strlen(a:decRight)
    let byteRightLen    = (a:lineLen / 2)       " First two lines of expression
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
    let cmd             .= a:commRight
    let cmd             .= "\<ESC>0i"
    let cmd             .= a:commLeft
    let cmd             .= bdrLeftXtra
    let cmd             .= repeat(a:decLeft, bdrLeftLen)
    let cmd             .= repeat(' ', a:padLeft)
    let cmd             .= "\<ESC>:s/\\s\\+$//e\<CR>"
    " }}}

    " Print parameters and variables for debugging {{{
    if s:debug
        echom 'DecorateHeader'
        echom '=====================' . '======'
        echom '    Variable         ' . 'Value'
        echom '    -----------------' . '------'
        echom '    commLeft.........' . a:commLeft
        echom '    decLeft..........' . a:decLeft
        echom '    padLeft..........' . a:padLeft
        echom '    padRight.........' . a:padRight
        echom '    decRight.........' . a:decRight
        echom '    rightComm........' . a:commRight
        echom '    lineLen..........' . a:lineLen
        echom '    hdrLen...........' . hdrLen
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
