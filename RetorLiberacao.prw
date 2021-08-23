#INCLUDE "TOTVS.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} RetorLiberacao
Rotina desenvolvida para realizar estorno de liberação de varios pedidos
para realização de teste de rotina de liberação automatica.
@type function
@version  191205P
@author endreo.figueiredo
@since 25/06/2021g
/*/

User Function RetorLiberacao()

	Local cQuery := ''
	Local cRetorno := FWInputBox("Digite a quantidade a ser Estornado - Padrao 10 ", "")

	Private cAliasQry := GetNextAlias()

	cQuery := " SELECT TOP " + IIF(Empty(cRetorno),' 10 ' , cRetorno ) + " C5_FILIAL AS FILIAL , C5_NUM AS NUM  FROM SC5010  "
	cQuery += " WHERE  "
	cQuery += " 	C5_NOTA     = '' "
	cQuery += " AND C5_XTPENT  != '' "
	cQuery += " AND C5_LIBEROK  = 'S' "
	cQuery += " ORDER BY R_E_C_N_O_  DESC "

	TcQuery cQuery NEW ALIAS (cAliasQry)

	DbSelectArea('SC9')
	SC9->(DbSetOrder(1)) //C9_FILIAL + C9_PEDIDO + C9_ITEM
	SC9->(DbGoTop())
	
	While !(cAliasQry)->(EOF())

		cFilAnt := (cAliasQry)->FILIAL

		DbSelectArea('SC5')
		SC5->(DbSetOrder(1)) //C5_FILIAL + C5_NUM
		SC5->(DbGoTop())
		
		DbSelectArea('SC6')
		SC6->(DbSetOrder(1)) //C6_FILIAL + C6_NUM + C6_ITEM
		SC6->(DbGoTop())

		//Se conseguir posicionar no pedido
		If SC5->(DbSeek(FWxFilial('SC5') + (cAliasQry)->NUM ))
		
			//Se conseguir posicionar nos itens do pedido
			If SC6->(DbSeek(FWxFilial('SC6') + (cAliasQry)->NUM))
			
				//Percorre todos os itens
				While ! SC6->(EoF()) .And. SC6->C6_FILIAL = FWxFilial('SC6') .And. SC6->C6_NUM == (cAliasQry)->NUM

					//Posiciona na liberação do item do pedido e estorna a liberação
					SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM))

					While  (!SC9->(Eof())) .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM
						VarInfo('PEDIDO E ITEM LIBERADO', {SC9->C9_FILIAL + SC9->C9_PEDIDO , SC9->C9_ITEM})
						SC9->(a460Estorna(.T.))
						SC9->(DbSkip())
					EndDo
		
					SC6->(DbSkip())
				EndDo
		
				RecLock("SC5", .F.)
					C5_LIBEROK := ""
				SC5->(MsUnLock())

			EndIF

		EndIf

		(cAliasQry)->(dbSkip())
	EndDo
	
Return
