function imOut=insertText(im,text,bottomright)
%This function inserts text into an image either at the bottomright, if
%bottomright=1 or at the upper left if bottomright=0
        topleftoffset=10;
        
         itext=uint8( 255.* ( 1-text2im(text)) );
        %create temp frame which is the right size and contains the tedt
        
        temp=uint8(zeros(size(im,1),size(im,2)));
        if bottomright
        temp( size(im,1)-size(itext,1):size(im,1)-1,size(im,2)-size(itext,2):size(im,2)-1)=uint8(itext);
        else
            temp( topleftoffset+1:topleftoffset+size(itext,1),topleftoffset+1:topleftoffset+size(itext,2))=uint8(itext);
        end
       
   
        imOut(:,:,1)=uint8(im(:,:,1)+temp);
        imOut(:,:,2)=uint8(im(:,:,2)+temp);
        imOut(:,:,3)=uint8(im(:,:,3)+temp);