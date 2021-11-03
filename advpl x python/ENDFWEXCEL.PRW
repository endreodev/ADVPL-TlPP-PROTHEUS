#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} ENDFWEXCEL
Realiza leitura de arquivo envia para conversor 
WebService e realiza e pega o retorno do xml em Json
@type function
@version 12.1.25
@author endreo.figueiredo
@since 27/08/2021
/*/

User Function ENDFWEXCEL()

    Local oRestClient   as object
    Local oFile         as object
    Local tmp           := getTempPath()
    Local oResult       := JsonObject():New()
    Local cUrl          := "http://localhost:21658"
    Local cPath         := "/convert"
    Local aHead         := {}
    Local cPostParms    := ''
    Local cGetDir       := ''   
    Local cResult       := ''    
    Local nX

    //Abre caixa de seleção de arquivos para escolha de arquivos a serem enviados
    cGetDir := tFileDialog( '*.xlsx | Execel (xlsx)','Selecao de Arquivos',, tmp, .F., GETF_MULTISELECT )
    
    //Classe de auxilo de leitura de arquivo texto,por linhas.
    //Lê sempre um buffer fixo, permitindo leitura de linha sem honerar o IO.
    oFile := FwFileReader():New(cGetDir)
    
    //Verifica se conseguiu abrir o arquivo
    If oFile:Open()
        
        //Estancia a Classe FWRest 
        oRestClient := FWRest():New(cUrl)
        
        //India o path/caminho para ws 
        oRestClient:SetPath(cPath)

        //Define head para envio ao WS
        aadd(aHead,'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryFbmu0bODj7UvfQEV')
        
        //Criando Body formato de envio de arquivo para envio para WS
        cPostParms += '------WebKitFormBoundaryFbmu0bODj7UvfQEV'
        cPostParms += CRLF
        cPostParms += 'Content-Disposition: form-data; name="file"; filename="'+cGetDir+'"' // passado o caminho e nome do arquivo 
        cPostParms += CRLF
        cPostParms += 'Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet '
        cPostParms += CRLF
        cPostParms += CRLF
        cPostParms += oFile:FullRead() //Retorna arquivo em formato aberto
        cPostParms += CRLF
        cPostParms += '------WebKitFormBoundaryFbmu0bODj7UvfQEV--''

        //Seta body na Classe FWRest    
        oRestClient:SetPostParams( cPostParms )
        
        //Fecha o arquivo que foi aberto
        oFile:Close()

        //Realiza o envio
        If oRestClient:Post(aHead)
            //Retorno do WS se ok
            varinfo('response', cResult := oRestClient:GetResult())
            
            //Verifica se tem retorno
             If !Empty(cResult)
                //Converte retorno Json String pra Objeto
                oResult:FromJson(cResult)

                //Faz um for e recupera cada linha 
                For nX:= 1 to Len(oResult['id'])
            
                    VarInfo('id'   , oResult['id'][nX]   )
                    VarInfo('nome' , oResult['nome'][nX] )
                
                Next nX

            EndIf 
            
        Else
            //Retorno do WS se ok
            varinfo('response',oRestClient:GetLastError())
        EndIf

        //Limpa objeto
        oRestClient := Nil
        //Mata Objeto
        FreeObj(oRestClient)

    Endif

    //Limpa Objeto
    oFile := Nil
    //Mata Objeto
    FreeObj(oFile)
     
Return
