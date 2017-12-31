select
    u.LOGIN,
    pos.NAME as Pos,
    par.NAME as Par,
    div.NAME as Div,
    org.NAME as Org
from
     S_USER u
     join S_PARTY_PER u_pos on u_pos.PERSON_ID = u.ROW_ID
     join S_POSTN pos on pos.ROW_ID = u_pos.PARTY_ID
     join S_BU org on org.PAR_ROW_ID = pos.BU_ID
     join S_ORG_EXT div on div.PAR_ROW_ID = pos.OU_ID
     join S_PARTY par_party on par_party.ROW_ID = pos.ROW_ID
     join S_POSTN par on par.ROW_ID = par_party.PAR_PARTY_ID
where u.LOGIN IN ('LOGIN1', 'LOGIN2')
