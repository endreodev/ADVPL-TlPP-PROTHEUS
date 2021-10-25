#INCLUDE "TOTVS.CH"

#DEFINE GRPEMP      1
#DEFINE CODFIL      2
#DEFINE NOME        6
#DEFINE NOMRED      7
#DEFINE DESCGRP     21
#DEFINE P_COMBOFIL  4

//-------------------------------------------------------------------
/*/{Protheus.doc} ExecUtil
Auxiliar na execução da de rotinas sem necessidade de acesso ao 
sistema.
Realizar Chamada via SmartClient
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

User Function ExecUtil()

    Private oExecUtil := ExecUtil():New()
    oExecUtil:View()
    
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Class ExecUtil 
    
    Data jExecUtil
    Data cFile
    Data lAbort
    Data aSM0
    Data aEmpresa 
    Data aEmpCombo
    Data aFilCombo

    Method New() Constructor
    Method View()
    Method Dialog()
    Method Login()
    Method Prepare() 
    Method RunProc()
    Method Execute()
    Method ValidFunction()
    Method ValidLogin()
    Method ValidSM0()
    Method ValidCombo()
    Method Encrypt()
    Method Decrypt()
    Method LoadCombo()    
    Method LoadSM0()
    Method LoadFile()
    Method SetEmpCombox()
    Method SetFilCombox()
    Method SetEmpFil()

EndClass

 //-------------------------------------------------------------------
 /*/{Protheus.doc} New
 description
 @author  Endreo Figueiredo
 @since   30-05-2021
 @version 1.0
 /*/
 //-------------------------------------------------------------------

Method New() Class ExecUtil
    
    Self:cFile    := "C:\Temp\ExecUtil_" + Lower(AllTrim(GetRmtInfo()[1])) + ".json"
    Self:jExecUtil := JsonObject():New()

    Self:aEmpresa  := {}
    Self:aEmpCombo := {}
    Self:aFilCombo := {}

    Self:LoadFile()
    Self:LoadSM0()
    Self:LoadCombo()

    MemoWrite(Self:cFile,Self:jExecUtil:ToJson())

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} Prepare
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method Prepare() Class ExecUtil

    RpcSetEnv(Self:jExecUtil['EMPRESA'],Self:jExecUtil['FILIAL'],Self:Decrypt(Self:jExecUtil['USERNAME']),Self:Decrypt(Self:jExecUtil['PASSWORD']),Self:jExecUtil['MODULO'],GetEnvServer(),{})

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} Open
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method View() Class ExecUtil

    MsApp():New() 
    oApp:CreateEnv()
 
    bMainInit := { || Self:Dialog() } 

    oApp:bMainInit  := bMainInit

    oApp:lMessageBar:= .T. 
    oApp:cModDesc:= 'TESTE DE ROTINAS'

    oApp:Activate()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} Dialog
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method Dialog() Class ExecUtil

    Local nTop    	:= 0
    Local nLeft   	:= 0
    Local nBottom 	:= 0
    Local nRight  	:= 0
    Local cTitle  	:= Nil
    Local lPixel 	:= .T.

    Local aSize := MsAdvSize()

    nBottom 	:= aSize[6]-60
    nRight  	:= aSize[5]-10

    lTransparent := .T.   

    If GetRPORelease() < "12.1.023" .And. GetBuild() < "7.00.131227A-20190114 NG"
        oMainWnd            := MSDialog():New(nTop, nLeft, nBottom, nRight,cTitle,,,,nOr(WS_VISIBLE,WS_POPUP),CLR_BLACK,CLR_WHITE,,,lPixel,,,,lTransparent)
        oMainWnd:bInit 		:= {|| Self:Login() }
        oMainWnd:lCentered	:= .F.
        oMainWnd:Activate()
    Else
        Self:Login()
    EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} RunProc
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method RunProc() Class ExecUtil

    While Self:Execute() 

    EndDo

    Final("TERMINO NORMAL")

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} Execute
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method Execute() Class ExecUtil

	Local aButtons 	:= {}
	Local nC
    Local lRet      := .T.
    Local oModal
    Local nTamFunc  := 200

	lIsBlind := .F.

	IF ( lIsBlind )
		__cInternet		:= "AUTOMATICO"
	Else
		__cInternet		:= NIL
	EndIF		

	IF (Type("oApp")=="O")
		oApp:lIsBlind	:= lIsBlind
		oApp:cInternet	:= __cInternet
	EndIF
	
    aHistory := {}
    For nC := 1 To Len(Self:jExecUtil['HISTORY'])
        Self:jExecUtil['HISTORY'][nC]['FUNCTION'] := PADR(Self:jExecUtil['HISTORY'][nC]['FUNCTION'],nTamFunc)
        aAdd(aHistory,Self:jExecUtil['HISTORY'][nC]['FUNCTION'])
    Next nC

    Self:jExecUtil['CURRENT'] := PADR(Self:jExecUtil['CURRENT'],nTamFunc)

    nOpc := 0

    If GetRPORelease() < "12.1.023"
        aSize := {080,200}
    Else
        aSize := {080,212}
    EndIf

    oModal  := FWDialogModal():New()
    oModal:SetEscClose(.T.)        
    oModal:setTitle("Executar")
    oModal:setSize(aSize[1],aSize[2])
    oModal:createDialog()
    oModal:addCloseButton({|| IIF(Self:ValidFunction(.F.),oModal:oOwner:End(),.T.),nOpc := 1 },"Executar")

    bAction1 := {|| Self:jExecUtil['HISTORY'] := {}, aHistory := {}, oTComboBox:SetItems(aHistory), oTComboBox:Refresh() } 

    aAdd(aButtons,{"PESQUISA",OemToAnsi( "&Limpar Histórico" ),bAction1 ,OemToAnsi( "Limpa histórico de funções..." ),,.T.,.F.})

    oModal:addButtons(aButtons)

    oContainer := TPanel():New( ,,, oModal:getPanelMain() ) 
    oContainer:Align := CONTROL_ALIGN_ALLCLIENT
    
    nLin	:= 10
    nCol    := 5
    nSpace	:= 7.4

    oTComboBox := TComboBox():New(nCol,nLin,{|u| If(PCount()>0, Self:jExecUtil['CURRENT'] := u, Self:jExecUtil['CURRENT'])},aHistory/*ITEMS*/,180,15,oContainer,,{||Self:ValidFunction(.T.)},{|| Self:ValidFunction(.T.) },,,.T.,,,,,,,,,"Self:jExecUtil['CURRENT']","Função",1) 
    
    If GetRPORelease() < "12.1.023"
        nCol += nSpace
        oTGet      := TGet():New(12.8,nLin,{|u| If(PCount()>0,Self:jExecUtil['CURRENT']:=u,Self:jExecUtil['CURRENT'])},oContainer,169,12,"@!S"+cValToChar(nTamFunc),{|| Self:ValidFunction(.F.) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","Self:jExecUtil['CURRENT']",,)
    Else
        nCol += nSpace
        oTGet      := TGet():New(12.6,nLin,{|u| If(PCount()>0,Self:jExecUtil['CURRENT']:=u,Self:jExecUtil['CURRENT'])},oContainer,169,12,"@!S"+cValToChar(nTamFunc),{|| Self:ValidFunction(.F.) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","Self:jExecUtil['CURRENT']",,)
    EndIf

    oModal:setInitBlock({||oTGet:SetFocus()})
    
    oModal:Activate()

    If nOpc == 1 .And. !Empty(Self:jExecUtil['CURRENT'])

        Self:jExecUtil['CURRENT'] := PADR(Self:jExecUtil['CURRENT'],nTamFunc)

        If (nPos := aScan(aHistory,{|x|UPPER(AllTrim(x)) == UPPER(AllTrim(Self:jExecUtil['CURRENT']))})) > 0

            Self:jExecUtil['HISTORY'][nPos]['DATATIME'] := DTOS(ddatabase) + " " + Time()
        
        Else
        
            oFunction := JsonObject():New()
            oFunction['FUNCTION'] := PADR(Self:jExecUtil['CURRENT'],nTamFunc)
            oFunction['DATATIME'] := DTOS(ddatabase) + " " + Time()
            aAdd(Self:jExecUtil['HISTORY'],oFunction)
        
        EndIf

        ASort(Self:jExecUtil['HISTORY'],,,{|x,y|x['DATATIME'] > y['DATATIME']})

        MemoWrite(Self:cFile,Self:jExecUtil:ToJson())
    Else
        lRet := .F.
    EndIf

    FreeObj(oModal)

    If lRet
	If ( AT("(",Self:jExecUtil['CURRENT']) > 0 )
	    &( Self:jExecUtil['CURRENT'] )
	Else 
	    &(Self:jExecUtil['CURRENT']+"()")
	EndIf
    EndIf

Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} ValidFunction
description
@author  Endreo Figueiredo
@since   18/11/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Method ValidFunction(lComboBox) Class ExecUtil

	Local lRet := .T.

	Default lComboBox := .F.

	If lComboBox
		oTComboBox:Refresh()
	Else
		lRet := Findfunction(Self:jExecUtil['CURRENT'])
	EndIf

	If ! lRet
		oTGet:SetFocus()
	EndIf

Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method ValidLogin() Class ExecUtil

    Local lRet    := .F. 

    Self:jExecUtil['USERNAME']   := PADR(Self:jExecUtil['USERNAME'],30)
    Self:jExecUtil['PASSWORD']   := PADR(Self:jExecUtil['PASSWORD'],30)

    PswOrder(2) 
    If  PswSeek(AllTrim(Self:jExecUtil['USERNAME'])) 
        If PswName(AllTrim(Self:jExecUtil['PASSWORD'])) 
            lRet := .T.     
        Else
            cMsg := "<b>Problema: </b>Senha do usuário <b>" + Alltrim(Self:jExecUtil['USERNAME']) + "</b> inválida." + CRLF + CRLF
            cMsg += "<b>Solução: </b>Digite a senha novamente."
            jModal['PASSWORD']:SetFocus() 
        EndIf      
    Else 
        cMsg := "<b>Problema: </b>Usuário <b>" + Alltrim(Self:jExecUtil['USERNAME']) + "</b> não encontrado." + CRLF + CRLF
        cMsg += "<b>Solução: </b>Informe um nome de usuário cadastrado."
        jModal['USERNAME']:SetFocus() 
    EndIf 

    If ! lRet
        MsgAlert(cMsg,"Atenção")
    EndIf

Return(lRet) 

//-------------------------------------------------------------------
/*/{Protheus.doc} ValidSM0
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method ValidSM0(cType) Class ExecUtil

    Local lRet := .T.

    If aScan(Self:aSM0,{|x|x[1]==Self:jExecUtil["EMPRESA"]}) == 0

        cMsg := "<b>Problema: </b>Código <b>" + Alltrim(Self:jExecUtil['EMPRESA']) + "</b> de empresa inválido." + CRLF + CRLF + CRLF
        cMsg += "<b>Solução: </b>Digite novamente a senha."

        jModal['EMPNAME']:SetFocus() 

        lRet := .F.

    ElseIf aScan(Self:aSM0,{|x|x[1]==Self:jExecUtil["EMPRESA"] .And. x[2]==Self:jExecUtil["FILIAL"]}) == 0

        cMsg := "<b>Problema: </b>Código <b>" + Alltrim(Self:jExecUtil['FILIAL']) + "</b> de filial inválido." + CRLF + CRLF + CRLF
        cMsg += "<b>Solução: </b>Informe um código válido."

        jModal['FILNAME']:SetFocus() 

        lRet := .F.

    EndIf

    If ! lRet
        MsgAlert(cMsg,"Atenção")
    EndIf

Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} Login
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method Login() Class ExecUtil

    Local lValid  := .F.
    Local nLin    := 10
    Local nSpace  := 20
    Local nSay    := 5
    Local nColSay := 10
    Local nColGet := 40
    Local nPosEmp := 0
    
    Private jModal := JsonObject():New()

    Self:jExecUtil['USERNAME'] := PADR(Self:Decrypt(Self:jExecUtil['USERNAME']),30)
    Self:jExecUtil['PASSWORD'] := PADR(Self:Decrypt(Self:jExecUtil['PASSWORD']),30)

    Self:jExecUtil['EMPRESA']  := PADR(Self:jExecUtil['EMPRESA'],Len(Self:aSM0[1][1]))
    Self:jExecUtil['FILIAL']   := PADR(Self:jExecUtil['FILIAL'],Len(Self:aSM0[1][2]))

    aInfo := GetAPOInfo("ExecUtil.PRW")

    VarInfo('nPosEmp',nPosEmp)

    cSubTitle := CRLF + "Release: " + GetRPORelease() + " Build: " + GetBuild()

    If ! Empty(aInfo)
        cSubTitle += CRLF + "Data: " + DTOC(aInfo[4]) + " - " + aInfo[5]
    EndIf

    jModal['MODAL']  := FWDialogModal():New()        
    jModal['MODAL']:SetEscClose(.T.)
    jModal['MODAL']:SetTitle("Login")
    jModal['MODAL']:SetSubTitle(cSubTitle)
    
    If GetRPORelease() < "12.1.023"
        jModal['MODAL']:SetSize(170,200)
    Else
        jModal['MODAL']:SetSize(180,200)
    EndIf

    jModal['MODAL']:createDialog()
    jModal['MODAL']:addCloseButton({|| IIF(lValid := (Self:ValidLogin() .And. Self:ValidSM0("F")) ,jModal['MODAL']:oOwner:End(),.T.),nOpc := 1 },"Executar")

    oContainer := TPanel():New( ,,, jModal['MODAL']:getPanelMain() ) 
    oContainer:Align := CONTROL_ALIGN_ALLCLIENT
    
    TSay():New(nLin+nSay,nColSay,{||"Usuário"},oContainer,,,,,,.T.,,,69,12,,,,,,)
    jModal['USERNAME'] := TGet():New(nLin,nColGet,{|u| If(PCount()>0,Self:jExecUtil['USERNAME']:=u,Self:jExecUtil['USERNAME'])},oContainer,69,12,"@S20",{|| .T. },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","Self:jExecUtil['USERNAME']")

    nLin += nSpace 

    TSay():New(nLin+nSay,nColSay,{||"Senha"},oContainer,,,,,,.T.,,,69,12,,,,,,)
    jModal['PASSWORD']   := TGet():New(nLin,nColGet,{|u| If(PCount()>0,Self:jExecUtil['PASSWORD']:=u,Self:jExecUtil['PASSWORD'])},oContainer,69,12,"@K20",{|| .T. },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","Self:jExecUtil['PASSWORD']")

    nLin += nSpace 

    TSay():New(nLin+nSay,nColSay,{||"Empresa"},oContainer,,,,,,.T.,,,69,12,,,,,,)

    jModal['EMPNAME'] := TComboBox():New(nLin,nColGet,{|u|if(PCount()>0,Self:jExecUtil['EMPNAME']:=u,Self:jExecUtil['EMPNAME'])},Self:aEmpCombo,150,20,oContainer,,{||Self:ValidCombo("EMPNAME",Self:jExecUtil['EMPNAME'])},,,,.T.,,,,,,,,,"Self:jExecUtil['EMPNAME']")

    nLin += nSpace 

    TSay():New(nLin+nSay,nColSay,{||"Filial"},oContainer,,,,,,.T.,,,69,12,,,,,,)

    jModal['FILNAME'] := TComboBox():New(nLin,nColGet,{|u|if(PCount()>0,Self:jExecUtil['FILNAME']:=u,Self:jExecUtil['FILNAME'])},Self:aFilCombo,150,20,oContainer,,{||Self:ValidCombo("FILNAME",Self:jExecUtil['FILNAME'])},,,,.T.,,,,,,,,,"Self:jExecUtil['FILNAME']")
  
    jModal['MODAL']:setInitBlock({||jModal['USERNAME']:SetFocus()})
    
    jModal['MODAL']:Activate()

    If lValid
    
        Self:jExecUtil['PASSWORD'] := Self:Encrypt(AllTrim(Self:jExecUtil['PASSWORD']))
        Self:jExecUtil['USERNAME'] := Self:Encrypt(AllTrim(Self:jExecUtil['USERNAME']))

        MemoWrite(Self:cFile,Self:jExecUtil:ToJson())

        FWMsgRun(, {|oSay| Self:Prepare() },"Aguarde...", "Carregando o ambiente...")
        Self:RunProc()
    
    Else
        Final("Login inválido")
    EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} Encrypt
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method Encrypt(cKey) Class ExecUtil

    Local nC := 0

    For nC := 1 To 10
        cKey := Encode64(cKey)
    Next nC

Return(cKey)

//-------------------------------------------------------------------
/*/{Protheus.doc} Decrypt
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method Decrypt(cKey) Class ExecUtil

    Local nC := 0

    For nC := 1 To 10
        cKey := Decode64(cKey)
    Next nC

Return(cKey)

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadCombo
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method LoadCombo() Class ExecUtil

    Local nC

    For nC := 1 To Len(Self:aSM0)

        cGrpEmp := Self:aSM0[nC][GRPEMP]
        cCodFil := Self:aSM0[nC][CODFIL]
        cNome   := Self:aSM0[nC][NOME]
        cNomRed := Self:aSM0[nC][NOMRED]

        cGrpName:= Self:aSM0[nC][DESCGRP]

        aFilial  := {cCodFil,cNome,cNomRed}

        If (nPEmp := aScan(Self:aEmpresa,{|x|x[1]==cGrpEmp})) > 0
            aAdd(Self:aEmpresa[nPEmp][3],aFilial)
            aAdd(Self:aEmpresa[nPEmp][4],cCodFil + " - " +cNomRed)
        Else
            aAdd(Self:aEmpresa,{cGrpEmp,cGrpName,{aFilial},{cCodFil + " - " +cNomRed}})
            aAdd(Self:aEmpCombo,cGrpEmp + " - " + cGrpName)
        EndIf

    Next nC

    Self:SetEmpFil()
    Self:SetEmpCombox()
    Self:SetFilCombox()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ValidCombo
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method ValidCombo(cProperty,cValue) Class ExecUtil

    If cProperty == "EMPNAME"
        
        Self:jExecUtil["EMPRESA"] := Self:aEmpresa[jModal[cProperty]:nAT][1]

        Self:aFilCombo := Self:aEmpresa[jModal[cProperty]:nAT][4]

        jModal['FILNAME']:SetItems(Self:aFilCombo)
        jModal['FILNAME']:Refresh()
    
    Else

        If jModal['FILNAME']:nAT == 0
            jModal['FILNAME']:nAT := 1
        EndIf

        Self:jExecUtil["FILIAL"] := Self:aEmpresa[jModal['EMPNAME']:nAT][3][jModal['FILNAME']:nAT][1]

    EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadSM0
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method LoadSM0() Class ExecUtil

    Local aSM0 := {}
    Local nC

    OpenSM0()

    aSM0        := FWLoadSM0()
    Self:aSM0   := {}

    DBSelectArea('SM0')

    For nC := 1 To Len(aSM0)
        
	    If SM0->(DBSeek(aSM0[nC][GRPEMP] + aSM0[nC][CODFIL])) ;
            .And. ! SM0->(Deleted())

            aAdd(Self:aSM0,aClone(aSM0[nC]))

        EndIf
    
    Next nC

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadSM0
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method LoadFile() Class ExecUtil

    If File(Self:cFile)
        Self:jExecUtil:FromJson(MemoRead(Self:cFile))
    Else
        Self:jExecUtil['CURRENT']    := Space(200)
        Self:jExecUtil['HISTORY']    := {}
        Self:jExecUtil['USERNAME']   := ""
        Self:jExecUtil['PASSWORD']   := ""
        Self:jExecUtil['EMPRESA']    := ""
        Self:jExecUtil['FILIAL']     := ""
        Self:jExecUtil['MODULO']     := "SIGAFAT"
        Self:jExecUtil['EMPNAME']    := ""
        Self:jExecUtil['FILNAME']    := ""
    EndIf

    If Self:jExecUtil['USERNAME'] == Nil
        Self:jExecUtil['USERNAME'] := ""
    EndIf

    If Self:jExecUtil['PASSWORD']   == Nil
        Self:jExecUtil['PASSWORD']   := ""
    EndIf

    If Self:jExecUtil['EMPRESA']  == Nil
        Self:jExecUtil['EMPRESA']  := ""
    EndIf

    If Self:jExecUtil['FILIAL']  == Nil
        Self:jExecUtil['FILIAL']  := ""
    EndIf

    If Self:jExecUtil['EMPNAME']  == Nil
        Self:jExecUtil['EMPNAME']  := ""
    EndIf

    If Self:jExecUtil['FILNAME']  == Nil
        Self:jExecUtil['FILNAME']  := ""
    EndIf

    If Self:jExecUtil['MODULO']  == Nil
        Self:jExecUtil['MODULO']  := "SIGAFAT"
    EndIf

    If Self:jExecUtil['CURRENT']  == Nil
        Self:jExecUtil['CURRENT']    := Space(200)
    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SetEmpFil
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method SetEmpFil() Class ExecUtil

    If Empty(Self:jExecUtil['EMPRESA']) ;
        .And. ! Empty(Self:aSM0)
        
        Self:jExecUtil['EMPRESA'] := Self:aSM0[1][GRPEMP]
        Self:jExecUtil['FILIAL']  := Self:aSM0[1][CODFIL]

    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SetEmpCombox
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method SetEmpCombox() Class ExecUtil

    If Empty(Self:jExecUtil['EMPNAME']) ;
        .And. ! Empty(Self:aEmpresa) ;
        .And. ! Empty(Self:jExecUtil['EMPRESA']) ;
        .And. (nPosEmp := aScan(Self:aEmpresa,{|x|x[1]==Self:jExecUtil['EMPRESA']})) > 0
    
        Self:jExecUtil['EMPNAME'] := Self:aEmpresa[nPosEmp][1] + " - " + Self:aEmpresa[nPosEmp][2]
    
    EndIf        

    If (nPosEmp := aScan(Self:aEmpresa,{|x|x[1]==Self:jExecUtil['EMPRESA']})) > 0
        Self:aFilCombo := Self:aEmpresa[nPosEmp][P_COMBOFIL]
    EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} SetFilCombox
description
@author  Endreo Figueiredo
@since   30-05-2021
@version 1.0
/*/
//-------------------------------------------------------------------

Method SetFilCombox() Class ExecUtil

    If Empty(Self:jExecUtil['FILNAME']) ;
        .And. ! Empty(Self:jExecUtil['FILIAL']) ;
        .And. ! Empty(Self:aFilCombo) ;
        .And. (nPosEmp := aScan(Self:aEmpresa,{|x|x[1]==Self:jExecUtil['EMPRESA']})) > 0 ;
        .And. (nPosFil := aScan(Self:aEmpresa[nPosEmp][3],{|x|x[1]==Self:jExecUtil['EMPRESA']})) > 0

        Self:jExecUtil['FILNAME'] := Self:aFilCombo[nPosFil]

    EndIf

Return()
