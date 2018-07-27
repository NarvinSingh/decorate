let s:debug = 0

function! decorate#DecorateLine(...)

    " Parameters {{{
    let a:commLeft      = get(a:000, 0, '"')
    let a:decLeft       = get(a:000, 1, ' ')
    let a:padLeft       = get(a:000, 2, ' ')
    let a:padRight      = get(a:000, 3, a:padLeft)
    let a:decRight      = get(
                        \   a:000,
                        \   4,
                        \   join(reverse(split(a:decLeft, '\zs')), ''))
    let a:commRight     = get(a:000, 5, '')
    let a:just          = get(a:000, 6, 'c')
    let a:lineLen       = get(a:000, 7, &colorcolumn !=? '' ? &colorcolumn : 80)
    " }}}

    " Variables {{{
    let hdrLen          = virtcol('$') - 1
    let commLeftLen     = strlen(a:commLeft)
    let commRightLen    = strlen(a:commRight)
    let padLeftLen      = strlen(a:padLeft)
    let padRightLen     = strlen(a:padRight)
    let maxHdrLen       = a:lineLen
    let maxHdrLen       -= padLeftLen
    let maxHdrLen       -= padRightLen
    let maxHdrLen       -= commLeftLen
    let maxHdrLen       -= commRightLen
    " }}}

    " Short circuit return if header is too long to decorate {{{
    if hdrLen > maxHdrLen
        echom 'DecorateHeader: Header is too long to decorate.'

        return
    endif
    " }}}

    " More variables based on justification parameter {{{
    if a:just ==? 'l'
        if a:decRight ==? ''
            let a:decRight = ' '
        endif

        let decLeftLen      = strlen(a:decLeft)
        let byteLeftLen     = 'N/A'
        let bdrLeftLen      = 1
        let bdrLeftMod      = 'N/A'
        let bdrLeftXtra     = ''
        let decRightLen     = strlen(a:decRight)
        let byteRightLen    = a:lineLen
        let byteRightLen    -= commLeftLen
        let byteRightLen    -= decLeftLen
        let byteRightLen    -= padLeftLen
        let byteRightLen    -= hdrLen
        let byteRightLen    -= padRightLen
        let byteRightLen    -= commRightLen
        let bdrRightLen     = byteRightLen / decRightLen
        let bdrRightMod     = byteRightLen % decRightLen
        let bdrRightXtra    = bdrRightMod > 0 ?
                            \   a:decRight[0:bdrRightMod - 1] :
                            \   ''
    elseif a:just ==? 'r'
        if a:decLeft ==? ''
            let a:decLeft = ' '
        endif

        let decRightLen     = strlen(a:decRight)
        let decLeftLen      = strlen(a:decLeft)
        let byteLeftLen     = a:lineLen
        let byteLeftLen     -= commLeftLen
        let byteLeftLen     -= padLeftLen
        let byteLeftLen     -= hdrLen
        let byteLeftLen     -= padRightLen
        let byteLeftLen     -= decRightLen
        let byteLeftLen     -= commRightLen
        let bdrLeftLen      = byteLeftLen / decLeftLen
        let bdrLeftMod      = byteLeftLen % decLeftLen
        let bdrLeftXtra     = bdrLeftMod > 0 ? a:decLeft[-bdrLeftMod:] : ''
        let byteRightLen    = 'N/A'
        let bdrRightLen     = 1
        let bdrRightMod     = 'N/A'
        let bdrRightXtra    = ''
    else    " All other justification values are center
        if a:decLeft ==? ''
            let a:decLeft = ' '
        endif

        if a:decRight ==? ''
            let a:decRight = ' '
        endif

        let decLeftLen      = strlen(a:decLeft)
        let byteLeftLen     = ((a:lineLen + 1) / 2) " First two lines of expr
        let byteLeftLen     -= ((hdrLen + 1) / 2)   " not simplified to take
        let byteLeftLen     -= padLeftLen           " advantage of int division
        let byteLeftLen     -= commLeftLen          " truncation
        let bdrLeftLen      = byteLeftLen / decLeftLen
        let bdrLeftMod      = byteLeftLen % decLeftLen
        let bdrLeftXtra     = bdrLeftMod > 0 ? a:decLeft[-bdrLeftMod:] : ''
        let decRightLen     = strlen(a:decRight)
        let byteRightLen    = (a:lineLen / 2)       " First two lines of expr
        let byteRightLen    -= (hdrLen / 2)         " not simplified to take
        let byteRightLen    -= padRightLen          " advantage of int division
        let byteRightLen    -= commRightLen         " truncation
        let bdrRightLen     = byteRightLen / decRightLen
        let bdrRightMod     = byteRightLen % decRightLen
        let bdrRightXtra    = bdrRightMod > 0 ?
                            \   a:decRight[0:bdrRightMod - 1] :
                            \   ''
    endif
    " }}}

    " The command {{{
    let cmd             = 'normal! A'
    let cmd             .= a:padRight
    let cmd             .= repeat(a:decRight, bdrRightLen)
    let cmd             .= bdrRightXtra
    let cmd             .= a:commRight
    let cmd             .= "\<esc>0i"
    let cmd             .= a:commLeft
    let cmd             .= bdrLeftXtra
    let cmd             .= repeat(a:decLeft, bdrLeftLen)
    let cmd             .= a:padLeft
    let cmd             .= "\<esc>:s/\\s\\+$//e\<cr>"
    let cmd             .= ":echo<cr>"
    " }}}

    " Print parameters and variables for debugging {{{
    if s:debug
        echom 'DecorateHeader'
        echom '=====================' . '======'
        echom '    Variable         ' . 'Value'
        echom '    -----------------' . '------'
        echom '    commLeft.........' . '<' .a:commLeft . '>'
        echom '    decLeft..........' . '<' .a:decLeft . '>'
        echom '    padLeft..........' . '<' .a:padLeft . '>'
        echom '    padRight.........' . '<' .a:padRight . '>'
        echom '    decRight.........' . '<' .a:decRight . '>'
        echom '    rightComm........' . '<' .a:commRight . '>'
        echom '    just.............' . '<' .a:just . '>'
        echom '    lineLen..........' . a:lineLen
        echom '    hdrLen...........' . hdrLen
        echom '    commLeftLen......' . commLeftLen
        echom '    commRightLen.....' . commRightLen
        echom '    padLeftLen  .....' . padLeftLen
        echom '    padRightLen .....' . padRightLen
        echom '    maxHdrLen........' . maxHdrLen
        echom '    decLeftLen.......' . decLeftLen
        echom '    byteLeftLen......' . byteLeftLen
        echom '    bdrLeftLen.......' . bdrLeftLen
        echom '    bdrLeftMod.......' . bdrLeftMod
        echom '    bdrLeftXtra......' . '<' .bdrLeftXtra . '>'
        echom '    decRightLen......' . decRightLen
        echom '    byteRightLen.....' . byteRightLen
        echom '    bdrRightLen......' . bdrRightLen
        echom '    bdrRightMod......' . bdrRightMod
        echom '    bdrRightXtra.....' . '<' .bdrRightXtra . '>'
        echom '    cmd..............' . '<' .cmd . '>'
        echom ''
    endif
    " }}}

    execute cmd
endfunction
