
FUNCTION blAddItem
	IF List.CurrentLength >= MAX_BUFFER_SIZE - 1 THEN
		blAddItem := -1;
	ELSE
		List.CurrentLength := List.CurrentLength + 1;
		List.List[List.CurrentLength - 1] := NewItem;
		blAddItem := 0;
	END_IF
END_FUNCTION

FUNCTION blRemoveItem
	//Check to make sure the item/index to remove is not larger than the size of the array
	IF Item >= MAX_BUFFER_SIZE - 1 THEN
		blRemoveItem := -1;
	ELSIF Item > List.CurrentLength THEN	//Check to make sure that the item/index is not greater than the current length of the list
		blRemoveItem := -2;
	ELSIF List.CurrentLength = 0 THEN	//Check to make sure we're not requesting an item from an empty list
		blRemoveItem := -3;
	ELSE
		toReturn := List.List[Item-1];
		List.CurrentLength := List.CurrentLength - 1;
		IF Item <> MAX_BUFFER_SIZE THEN
			size := MAX_BUFFER_SIZE - Item - 1;
			brsmemmove(ADR(List.List[Item-1]),ADR(List.List[Item]),size);//preform a shift of the entire array
		ELSE 
			List.List[Item-1] := 0;
		END_IF
		blRemoveItem := toReturn;		
	END_IF
END_FUNCTION

FUNCTION blResetList
	brsmemset(ADR(List),0,SIZEOF(List));
END_FUNCTION

FUNCTION blContains
	
END_FUNCTION