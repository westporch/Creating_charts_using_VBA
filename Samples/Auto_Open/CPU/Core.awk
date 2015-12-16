#!/usr/bin/awk -f

BEGIN {
	printf("%2s %4s(%%) %10s\n", "Core", "Percent", "test") 
	
	for(i=0; i<10; i++)
	{
		printf("+")
	};
}
