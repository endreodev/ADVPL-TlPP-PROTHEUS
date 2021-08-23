#INCLUDE 'TOTVS.CH'
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} FINA666 
Ponto de MVC rotina se Solicitação de viagem
@type function
@version 12.1.25
@author endreo.figueiredo
@since 16/08/2021
/*/

User Function FINA666()

    Local aParams   := ParamIXB            //Parâmetros do Ponto de Entrada
    Local oObj      := JsonObject():New()  //Objeto do formulário ou do modelo, conforme o caso
    Local xRet      := .T.                 //Retorno
    Local nX,nOper  
 
    //Verifica se possui os parâmetros
    If !(aParams == Nil)

        oObj['MODEL']   := aParams[01] //Objeto do formulário ou do modelo, conforme o caso
        oObj['EVENTO']  := aParams[02] //ID do local de execução do ponto de entrada
        oObj['IDFORM']  := aParams[03] //ID do formulário
 
        //Verifica se é TudoOK
        If oObj['EVENTO'] == "MODELPRE"
        //Verificação do model
        ElseIf oObj['EVENTO'] == 'MODELVLDACTIVE'
            nOper := oObj['MODEL']:nOperation

            If nOper == 3 .Or. nOper == 4

                oModel := oObj['MODEL']:GetModel('FW3MASTER')
                aadd(oModel:OFORMMODELSTRUCT:AFIELDS , { "Cid. Orig", "Cidade Origem" , "FW3_XNOMOR", "C", 40, 0, { || .T. } , NIL, {}, .F., NIL, .F., .F., .F., "" })
                aadd(oModel:OFORMMODELSTRUCT:AFIELDS , { "Cid. Dest", "Cidade Destino", "FW3_XNOMDE", "C", 40, 0, { || .T. } , NIL, {}, .F., NIL, .F., .F., .F., "" }) 

                oObj['MODELFW4'] :=  oObj['MODEL']:GetModel('FW4DETAIL'):OFORMMODELSTRUCT:AFIELDS

                For nX:= 1 to Len(oObj['MODELFW4'])
                    //Define campos como obrigatórios
                    If oObj['MODELFW4'][nX][3] $ 'FW4_TIPO|FW4_OBS' 
                        oObj['MODELFW4'][nX][10] := .T.
                    EndIf 
                    //Define inicializador do campo
                    If oObj['MODELFW4'][nX][3] $ 'FW4_TIPO' 
                        oObj['MODELFW4'][nX][11] := {|| '6' }
                    EndIf 

                Next nX
            EndIf 

        //Validação de Varios Eventos
        ElseIf oObj['EVENTO'] == 'FORMPRE' 

            nOper := oObj['MODEL']:getoperation()

            If nOper == 3 .Or. nOper == 4
           
                //Model FW3MASTER
                If oObj['IDFORM'] == 'FW3MASTER'

                    oObj['OVIEW'] := FWViewActive()

                    If ( ValType(oObj['OVIEW']) == "O" ) 

                        oStruct := oObj['OVIEW']:GetViewStruct("FW3MASTER")
                        
                        If !( AScan(oStruct:GetFields(), {|x| AllTrim(x[01]) $ 'FW3_XNOMOR|FW3_XNOMDE' }) > 0 )
                            oStruct:AddField( "FW3_XNOMOR" , "06" , "Cid. Orig" , "Cidade Origem" , Nil , "GET" , "@!" , Nil , "" , .F. ,  "" ,  "" ,  {} ,  0 ,  "" , .F. ,  "" , .F. , 0 , )
                            oStruct:AddField( "FW3_XNOMDE" , "10" , "Cid. Orig" , "Cidade Origem" , Nil , "GET" , "@!" , Nil , "" , .F. ,  "" ,  "" ,  {} ,  0 ,  "" , .F. ,  "" , .F. , 0 , )
                        EndIf  

                        oStruct:SetProperty( 'FW3_SOLICI' ,  MVC_VIEW_ORDEM ,  '01' )      
                        oStruct:SetProperty( 'FW3_NACION' ,  MVC_VIEW_ORDEM ,  '02' )      
                        oStruct:SetProperty( 'FW3_CODORI' ,  MVC_VIEW_ORDEM ,  '03' ) 
                        oStruct:SetProperty( 'FW3_DESORI' ,  MVC_VIEW_ORDEM ,  '04' ) 
                        oStruct:SetProperty( 'FW3_XCDORI' ,  MVC_VIEW_ORDEM ,  '05' )  
                        oStruct:SetProperty( 'FW3_CODDES' ,  MVC_VIEW_ORDEM ,  '07' )   
                        oStruct:SetProperty( 'FW3_DESDES' ,  MVC_VIEW_ORDEM ,  '08' )   
                        oStruct:SetProperty( 'FW3_XCDDES' ,  MVC_VIEW_ORDEM ,  '09' )      
                        oStruct:SetProperty( 'FW3_DTINI'  ,  MVC_VIEW_ORDEM ,  '11' )      
                        oStruct:SetProperty( 'FW3_DTFIM'  ,  MVC_VIEW_ORDEM ,  '12' )      
                        oStruct:SetProperty( 'FW3_CLIENT' ,  MVC_VIEW_ORDEM ,  '13' )      
                        oStruct:SetProperty( 'FW3_LOJA'   ,  MVC_VIEW_ORDEM ,  '14' )   
                        oStruct:SetProperty( 'FW3_NOME'   ,  MVC_VIEW_ORDEM ,  '15' ) 
                        oStruct:SetProperty( 'FW3_STATUS' ,  MVC_VIEW_ORDEM ,  '16' ) 

                    EndIf
                
                EndIf
            
            EndIf

        ElseIf oObj['EVENTO'] == 'FORMPOS'
        ElseIf oObj['EVENTO'] == 'FORMLINEPRE'
        ElseIf oObj['EVENTO'] == 'FORMLINEPOS'
        ElseIf oObj['EVENTO'] == 'MODELCOMMITTTS'
        ElseIf oObj['EVENTO'] == 'MODELCOMMITNTTS'
        ElseIf oObj['EVENTO'] == 'FORMCOMMITTTSPRE'
        ElseIf oObj['EVENTO'] == 'FORMCOMMITTTSPOS'
        ElseIf oObj['EVENTO'] == 'BUTTONBAR'
        EndIf
        
    EndIf

Return xRet

