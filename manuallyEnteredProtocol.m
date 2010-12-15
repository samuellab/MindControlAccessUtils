%% Manually entered protocol File

            protocolGridSize=[5,100];
            
            rawprotocol=[];
            
            rawprotocol(end+1,:)= [ -4, 0, -1, 0, -1, 14, -4, 14 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 0, 1, 0, 1, 14, -1, 14 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 0, 3, 0, 3, 14, 1, 14 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -4, 14, -1, 14, -1, 28, -4, 28 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 14, 1, 14, 1, 28, -1, 28 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 14, 3, 14, 3, 28, 1, 28 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -4, 28, -1, 28, -1, 42, -4, 42 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 28, 1, 28, 1, 42, -1, 42 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 28, 3, 28, 3, 42, 1, 42 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -4, 42, -1, 42, -1, 56, -4, 56 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 42, 1, 42, 1, 56, -1, 56 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 42, 3, 42, 3, 56, 1, 56 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -4, 56, -1, 56, -1, 70, -4, 70 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 56, 1, 56, 1, 70, -1, 70 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 56, 3, 56, 3, 70, 1, 70 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -4, 70, -1, 70, -1, 84, -4, 84 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 70, 1, 70, 1, 84, -1, 84 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 70, 3, 70, 3, 84, 1, 84 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -4, 84, -1, 84, -1, 98, -4, 98 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ -1, 84, 1, 84, 1, 98, -1, 98 ];
 
         
            
            
            
            rawprotocol(end+1,:)= [ 1, 84, 3, 84, 3, 98, 1, 98 ];

            
            %Convert this raw protocol format into a 3d matrix 
            %Suc that the i'th protocol is protocol(:,:,i)
            % and the vertices coordinate in the dorsal ventral dimension are the
            % first column and the vertices coordinate in the anterior-posterior
            % dimension are the second column
            clear protocol;
            for k=1:size(rawprotocol,1)
                protocol(:,:,k)=reshape(rawprotocol(k,:),2,[])';
            end
            clear rawprotocol;
            clear k;