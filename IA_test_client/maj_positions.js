function maj_pions(){
    for (let equipe=1;equipe<5;equipe++){
        for (let velo=1;velo<4;velo++){
            var css_elem = document.querySelector('#p'+equipe+velo)
            const position = get_position(equipe,velo)
            css_elem.style.setProperty('left',position[0]+'%')
            css_elem.style.setProperty('top',position[1]+'%')
        }
    }


}


