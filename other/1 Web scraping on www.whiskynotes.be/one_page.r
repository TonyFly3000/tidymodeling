


one_page_function <- function(review_url){
  #review_url='https://www.whiskynotes.be/2010/bowmore/bowmore-9y-1997-cigar-malt/'
  
  #review_url= 'https://www.whiskynotes.be/2020/laphroaig/williamson-2010-the-whisky-jury/'
  
  print(review_url)
  review_page <- read_html(review_url)
  
  page_class=review_page  %>% html_elements(".cat-links a") %>% html_text2()
  page_class=str_flatten(page_class,collapse = "-")
  
  bottle_name=review_page  %>% html_elements(".entry-content h2") %>% html_text2()
  # remove empty
  bottle_name=bottle_name[nzchar(bottle_name)]
  # remove space element
  bottle_name=bottle_name[nchar(bottle_name)>2]
  
  
  # remove ? mark non bottle name element
  bottle_name=bottle_name[!bottle_name%>% str_detect("\\?")]
  # remove Drams Delivered revisited  non bottle name element
  bottle_name=bottle_name[ !bottle_name == 'Drams Delivered revisited']
  print(bottle_name) 
  
  bottle_review_raw=review_page  %>% html_elements("p") %>% html_text()
  bottle_review=unlist(strsplit(bottle_review_raw,"(?= Nose: )",perl = TRUE))
  bottle_review=unlist(strsplit(bottle_review,"(?= Mouth: )",perl = TRUE))
  bottle_review=unlist(strsplit(bottle_review,"(?= Finish: )",perl = TRUE))
  
  bottle_review_Nose=bottle_review[bottle_review %>% str_detect('Nose:|Attractive nose:')]
  bottle_review_Nose=bottle_review_Nose[nzchar(bottle_review_Nose)]
  
  bottle_review_Mouth=bottle_review[bottle_review %>% str_detect('Mouth:')]
  bottle_review_Mouth=bottle_review_Mouth[nzchar(bottle_review_Mouth)]
  
  bottle_review_Finish=bottle_review[bottle_review %>% str_detect('Finish:')]
  bottle_review_Finish=bottle_review_Finish[nzchar(bottle_review_Finish)]
  
  ########### add dummy score if there is no score review #########
  # bottle_review_Finish_score=bottle_review[bottle_review %>% str_detect('Finish:|Score:')][-1]
  
  # # bottle_review_Finish_score2=bottle_review_Finish_score
  
  
  # order=1
  # for (word in bottle_review_Finish_score){
  #   print(word)
  #   print(order)
  #   print(order%%2)
  #   print(word %>% str_detect('Score:'))
  #   print(order%%2==0 & word %>% str_detect('Score:')==FALSE)
  #   if (order%%2==0 & word %>% str_detect('Score:')==FALSE){
  #     print('adding add dummy score if there is no score review ')
  #     bottle_review_Finish_score2=append(bottle_review_Finish_score2,'Score:00/100',order-1)
  #   }else{
  #   }
  #   order=order+1
  #   }
  ################################################
  
  #"^[:digit:]+$" 
  ################# score  
  first_bottle_score=review_page  %>% html_elements(".entry-score") %>% html_text2()
  
  bottle_score=review_page  %>% html_elements("strong") %>% html_text2()
  
  bottle_score2=bottle_score %>% str_remove("100")%>% str_remove("/") %>% str_remove("/100.") %>% str_remove("/100")%>% str_remove("Score:")%>%str_trim() %>%  str_match("^[0-9]{2}$") %>% as.data.frame() %>% filter(is.na(V1)==FALSE)
  
  bottle_score2=bottle_score2 %>% mutate(V1=str_replace(V1,'/100',''))%>% rename(all_page_score=V1) 
  
  # if no other score then use first score
  if(identical(bottle_score, character(0))==TRUE|nrow(bottle_score2)==0){
    all_page_score=first_bottle_score %>% tibble()%>% rename(all_page_score='.') 
    
    # if no first score then use other score
  }else if (identical(first_bottle_score, character(0))==TRUE){
    all_page_score=bottle_score2
    
    # the other score have same length as bottle.aka the first score appear twices
    
  }else if (nrow(bottle_score2)==length(bottle_review_Nose)){
    all_page_score=bottle_score2
    
    # if both have first score and other score then combine    
  }else{
    #bottle_score=bottle_score %>% str_match('[0-9][0-9]') %>% as.data.frame() %>% filter(is.na(V1)==FALSE)
    all_page_score=rbind(first_bottle_score,bottle_score2)
  }
  ##############################
  page_published_date=review_page  %>% html_elements(".published") %>% html_text2()
  
  
  page_title=review_page  %>% html_elements(".entry-title") %>% html_text2()
  
  if(nrow(all_page_score)!=length(bottle_name)){all_page_score=0}
  if(length(bottle_review_Nose)!=length(bottle_name)){bottle_review_Nose='no comment'}
  if(length(bottle_review_Mouth)!=length(bottle_name)){bottle_review_Mouth='no comment'}
  if(length(bottle_review_Finish)!=length(bottle_name)){bottle_review_Finish='no comment'}
  
  
  
  one_page_review=tibble(bottle_name,bottle_review_Nose,bottle_review_Mouth,bottle_review_Finish,all_page_score,page_class,page_published_date,page_title,review_url) 
  
  
  Sys.sleep(runif(n=1, min=0.1, max=0.8))
  #print(one_page_review)
  print(dim(one_page_review))
  #remove(review_page)
  return(one_page_review)
}