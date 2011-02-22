%% Manually entered protocol File

            protocolGridSize=[21,100];
            
            rawprotocol=[];
            rawprotocol(end+1,:) =[ -3, 30, 9, 30, 9, 38, -3, 38 ];
            rawprotocol(end+1,:) =[ -9, 38, 3, 38, 3, 46, -9, 46 ];
            rawprotocol(end+1,:) =[ -5, 62, 7, 62, 7, 70, -5, 70 ];
            rawprotocol(end+1,:) =[ -4, 86, 8, 86, 8, 94, -4, 94 ];
           rawprotocol(end+1,:) =[ -12, 30, 12, 30, 12, 0, -12, 0 ];
           rawprotocol(end+1,:) =[ -12, 86, 12, 86, 12, 70, -12, 70 ];
           rawprotocol(end+1,:) = [ -12, 0, 12, 0, 12, 99, -12, 99 ];
            rawprotocol(end+1,:) =[ -12, 0, 12, 0, 12, 46, -12, 46 ];
            rawprotocol(end+1,:)= [ -12, 62, 12, 62, 12, 99, -12, 99 ];

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