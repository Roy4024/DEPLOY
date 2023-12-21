@org_name=''
@org_name_type=''
@org_name_std=''
#@global=''
@acct_type=''
def filter(event)
	if(event.get('type') )
	 eventtype=event.get('type')
        listidentifier=[]  
        listskaddress=[] 
		listaddress=[]  
		listban=[] 
		listaccounts=[] 
		listgkrelatedparty = []
     

		
        if((eventtype =='allkeysGKmacro' and  event.get('gk_id')))
			
			if (event.get('review'))
            			event.set('reviewed',event.get('review'))
			end
			
			if(event.get('gk_addr_details'))
				listaddress=populateaddress(event.get('gk_addr_details'),eventtype)
				#if !(listaddress == [])
					event.set('contactMedium',listaddress)
				#end
			end
			if(event.get('iden_gk_details'))
				listidentifier=populateorgIdentifier( event.get('iden_gk_details'),eventtype )
				if !(listidentifier == [])
					event.set('organizationIdentification',listidentifier)
				end
			end
			
			
			if(event.get('pa_ban_details'))
				listban=populateorgban( event.get('pa_ban_details') )
				if !(listban == [])
					event.set('ban',listban)
				end
			end
			
					    
            		if(event.get('gkaccounts_ca_details')) 	
				listaccounts = populateaccount(event.get('gkaccounts_ca_details'),eventtype)
				if !(listaccounts == [])
					event.set('bellExternalReference',listaccounts)
				end	
			end				
		
        elsif(eventtype == 'allkeysGKmacro' and  event.get('silverkey'))
                  
            if(event.get('ext_addr_details'))                                                      
                listskaddress=populateextaddress(event.get('ext_addr_details'))
                if !(listskaddress == [])
                    event.set('contactMedium',listskaddress)	
                end
            end

            if(event.get('int_addr_details'))                                                       
            listskaddress=populateextaddress(event.get('int_addr_details'))
            if !(listskaddress == [])
                event.set('contactMedium',listskaddress)	
            end
            end

            if(event.get('ext_bellext_details')) 	                                         
            listaccounts = populateaccount(event.get('ext_bellext_details'),eventtype)
            if !(listaccounts == [])
                event.set('bellExternalReference',listaccounts)
            end
            end
            
            if(event.get('int_bellext_details')) 	                                           
            listaccounts = populateaccount(event.get('int_bellext_details'),eventtype)
            if !(listaccounts == [])
                event.set('bellExternalReference',listaccounts)
            end
            end

            if(event.get('int_ident_details'))                                                 
            listidentifier=populateorgIdentifier(event.get('int_ident_details'),eventtype)
            if !(listidentifier == [])
                event.set('organizationIdentification',listidentifier)	
            end
            end
 

        elsif (eventtype =='GranualGK')						
            if(event.get('gk_addr_details'))
                #event.set('siteId',event.get('gk_addr_details')[0]['site_id'])
                listaddress=populateaddress(event.get('gk_addr_details'),eventtype)
                #if !(listaddress == [])
                    event.set('contactAddress',listaddress)
                #end
            end
            if(event.get('iden_gk_details'))
                listidentifier=populateorgIdentifier( event.get('iden_gk_details') ,eventtype )
                if !(listidentifier == [])
                    event.set('organizationIdentification',listidentifier)
                end
            end
	    if(event.get('gk_rel_details'))
		listgkrelatedparty=populateorgrelatedparty( event.get('gk_rel_details'))
		if !(listgkrelatedparty == [])
			event.set('relatedParty',listgkrelatedparty)
		end
	    end
			   
        else 
		    return []
		end


	return [event]	
	else
		return []
	end	
	
end	

def populateaddress(inputaddressList,eventtype)
listaddress=[]
inputaddressList.each do |address|
    if  ((eventtype =='GranualGK' or eventtype =='GranualGKfastdb'))	

		if (address['addr_type'] == 'Secondary')
			address['addr_type'].gsub! 'Secondary', 'Secondary Location'
	    end 
		if (address['addr_type'] == 'Customer')
			address['addr_type'].gsub! 'Customer', 'Customer Address'
	    end
if(address['main_cust_ind']=='Y')
		add = {'addrType' => address['addr_type'],  'street1' => address['addr_line_one'], 'street2' => address['addr_line_two'], 'street3' => address['addr_line_three'], 'city' => address['city_name'], 'stateOrProvince' => address['province'], 'postcode' => address['postal_code'], 'country' => address['country']}
	add.delete_if { |k,v| v.nil? }					
	if !(listaddress.include? (add))
		listaddress <<  add			
	end
end
	end
	if (eventtype=='macroNontmf')
		add = {'addr_type' => address['addr_type'],  'addr_line_one' => address['addr_line_one'], 'addr' => address['addr'], 'city' => address['city_name'], 'province' => address['province'], 'postal_code' => address['postal_code'], 'country' => address['country']}
	add.delete_if { |k,v| v.nil? }					
	if !(listaddress.include? (add))
		listaddress <<  add			
	end

	end
	if (eventtype=='Macrotmf' or eventtype=='Macrotmfefast' or eventtype=='allkeysmacro')
		add = {'addrType' => address['addr_type'],  'street1' => address['addr_line_one'], 'street2' => address['addr_line_two'], 'street3' => address['addr_line_three'], 'city' => address['city_name'], 'stateOrProvince' => address['province'], 'postcode' => address['postal_code'], 'country' => address['country'],'addr' => address['addr']}	
    	add.delete_if { |k,v| v.nil? }					
	if !(listaddress.include? (add))
		listaddress <<  add			
	end

	end
	if ( eventtype =='GranualIndi' or eventtype =='GranualIndifastdb' )
		add = {'addrType' => address['addr_type'],  'street1' => address['addr_line_one'], 'street2' => address['addr_line_two'], 'street3' => address['addr_line_three'], 'city' => address['city_name'], 'stateOrProvince' => address['province'], 'postcode' => address['postal_code'], 'country' => address['country'],'addr' => address['addr'],'streetNumber' => address['street_number'],'streetName' => address['street_name'],'streetSuffix' => address['street_suffix'],'residenceNum' => address['residence_num'],'provinceStateTypeCode' => address['prov_type_code'],'provinceStateName' => address['prov_type_name'],'latitudeDegrees' => address['latitude_degrees'],'longitudeDegrees' => address['longitude_degrees'],'locationKey' => address['location_key'],'hasAsset' => address['has_asset']}	
    	add.delete_if { |k,v| v.nil? }					
	if !(listaddress.include? (add))
		listaddress <<  add			
	end

	end	
end
return listaddress
end 
                   
def populateorgIdentifier( inputidentifierList ,eventtype)
    listidentifier=[]
    inputidentifierList.each do |identifier|
    if (eventtype=='allkeysmacro')
        #if(identifier['identifier_type'] != 'customerClli')
    if !['BillOpenDate','Region'].include?(identifier['identifier_type'])
            if (identifier['main_acc_ind'] )
                elkidentifier = {'preferred' => 'true','identificationId' => identifier['identifier'], 'identificationType' => identifier['identifier_type']} 
                else
                    elkidentifier = {'identificationId' => identifier['identifier'], 'identificationType' => identifier['identifier_type']} 
            end
        elkidentifier.delete_if { |k,v| v.nil? }	
        if !(listidentifier.include? (elkidentifier))
            listidentifier <<  elkidentifier           
        end
        end	  
    end	
    
    if (eventtype =='GranualGK' )
        if !['BillOpenDate','Region','customerClli','customerType'].include?(identifier['identifier_type'])
                elkidentifier = {'identificationId' => identifier['identifier'], 'identificationType' => identifier['identifier_type']} 
                elkidentifier.delete_if { |k,v| v.nil? }	
                if !(listidentifier.include? (elkidentifier))
                    listidentifier <<  elkidentifier           
                    end
        end
    end
    end
    return listidentifier
    end




def populateorgban( inputbanList)
    listban=[]
        inputbanList.each do |gk_ban|
            if (gk_ban['ban'])
                        banstd=''
                        banraw = gk_ban['ban']
                        ban_arr=banraw.split(' ')
                            if (ban_arr.length==2 and ban_arr[1].length==3 )
                                banstd=ban_arr[0]
                            else
                                banstd=banraw.delete(' ')
                            end 
                        bb = {'ban' => banraw,'banStd' =>banstd}  
                        bb.delete_if { |k,v| v.nil? }
                            if !(listban.include? (bb))
                                listban <<  bb            
                            end
            end		
    end
    return listban
    end
        
def populateextaddress(inputextaddressList)
    listextaddress = []
    inputextaddressList.each do |extaddress|
            add = {'addrType' => extaddress['addr_type'],  'street1' => extaddress['addr_line_one'], 'street2' => extaddress['addr_line_two'], 'city' => extaddress['city_name'], 'stateOrProvince' => extaddress['prov_name'], 'postcode' => extaddress['postal_code'], 'country' => extaddress['country_name'],'addr' => extaddress['addr'],'streetNumber' => extaddress['street_number'],'streetName' => extaddress['street_name'],'streetSuffix' => extaddress['street_suffix'],'residenceNum' => extaddress['residence_num'],'provinceStateTypeCode' => extaddress['prov_type_code'],'provinceStateName' => extaddress['prov_name'],'latitudeDegrees' => extaddress['latitude_degrees'],'longitudeDegrees' => extaddress['longitude_degrees'],'locationKey' => extaddress['location_key'],'addrMatchType' => extaddress['match_type_name']}	
            add.delete_if { |k,v| v.nil? }					
        if !(listextaddress.include? (add))
            listextaddress <<  add			
        end
    end
    return listextaddress
    end


def populateorgrelatedparty( inputlistgkrelList )
    listgkrelatedparty = []
    inputlistgkrelList.each do |rel|
    related = {'relatedId' => rel['parent_id'],  'role' => rel['roletp'], 'name' => rel['org_name']}	
                    related .delete_if { |k,v| v.nil? }
    
                    if !(listgkrelatedparty.include? (related))
                        listgkrelatedparty <<  related	 		
                    end
        end		 
    return listgkrelatedparty
    end

def populateSecsk(inputSecskList)
    listsecsk = []
    inputSecskList.each do |secsk_account|
    sec = {'id' => secsk_account['secondary_sk']}
    sec.delete_if { |k,v| v.nil? }
    if !(listsecsk.include? (sec))
            listsecsk <<  sec				
    end 
    end
    return listsecsk
    end


def populateaccount(inputaccountList,eventtype)
    listaccounts=[]
    inputaccountList.each do |ca_account|
        if ((eventtype=='Macrotmf' and ca_account['source_id']) or (eventtype=='Macrotmfefast' and ca_account['source_id']) or (eventtype=='allkeysmacro' and ca_account['source_id']))
            
            if (ca_account['main_ca_indicator'] or ca_account['MAIN_MAXIMO_IND'] or ca_account['main_ca'] )
                ca = {'preferred' => 'true','externalId' => ca_account['source_id'] , 'externalReferenceType' => 'Customer','sourceSystemId' => ca_account['source_system'] }
            else 
                ca = {'externalId' => ca_account['source_id'] , 'externalReferenceType' => 'Customer','sourceSystemId' => ca_account['source_system'] }
            end
        ca.delete_if { |k,v| v.nil? }
        if !(listaccounts.include? (ca))
            listaccounts <<  ca		
        end
    
            end
    
        if ((eventtype=='Macrotmf' and ca_account['source_id'].nil?) or (eventtype=='Macrotmfefast' and ca_account['source_id'].nil?) or (eventtype=='allkeysmacro' and ca_account['source_id'].nil?))
                ca = {'externalId' => ca_account['source_id'] ,'externalReferenceType' => nil, 'sourceSystemId' => ca_account['source_system'] }
                ca.delete_if { |k,v| v.nil? }
        if !(listaccounts.include? (ca))
            listaccounts <<  ca		
        end
    
            end
    end
    return listaccounts
    end 
