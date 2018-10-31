var allClasses = new Array();

var currentElement;
var currentPath= new Array();

var winLoc = window.location;

var currentButton;
var layerHistory = new Array();

var origUrl = location.href

window.onload = function(){
	showElement("introText")
}

//window.setInterval(tjekUrl,100)
function tjekUrl(){
	//alert(window.location.hash)
	if("#"+currentElement != winLoc.hash){
		window.status = winLoc.hash;
		//doBack()
	}
}

function toggleDetails(elementId){
	var imgElement = document.getElementById(elementId.replace("div|","img|"));
	var element = document.getElementById(elementId);
	if(element.className == "detailsVisible"){
		element.className = "hiddenElement";
		imgElement.src = "OrteliusAjax/foldud.gif";
	}else{
		element.className = "detailsVisible";
		imgElement.src = "OrteliusAjax/foldind.gif";
	}
}

function toggleTreeElement(elementId){
	
	//change open / close ikon

	var imgElement = document.getElementById(elementId.replace("div|","img|"));
	
	element = document.getElementById(elementId);
	if(element.className == "packageTreeVisible"){
		element.className = "hiddenElement";
		imgElement.src = "OrteliusAjax/foldud.gif";
	}
	else{
		imgElement.src = "OrteliusAjax/foldind.gif";
		element.className = "packageTreeVisible";
	}
	}
	
function showHideAllTreeElement(doShow){
	
	}

function showElement(elementId){
	if(elementId.indexOf("@") ==0){
		var url = elementId.replace("@","");
		window.open("http://www.google.com/search?q="+url+"+Actionscript");
		return;
	}
	
	
	//remove highlights
	for(var i=0;i<currentPath.length;i++){
		document.getElementById(currentPath[i]).className = "nonChoosen";
	}
	currentPath= new Array();
	
	//highlight packagepath
	var elementParts = elementId.split(".");
	var elementIdTemp = "a|";
	for(var i=0;i<elementParts.length-1;i++){
		elementIdTemp+=elementParts[i];
		
		if(document.getElementById(elementIdTemp)){
			document.getElementById(elementIdTemp).className = "choosen";
			currentPath.push(elementIdTemp);	
		}
		
		elementIdTemp+="_"
	}
	
	//document.body.innerHTML += "<a name=\""+elementId+"\"></a>";
	
	winLoc.hash = "#"+elementId
	
	//alert(winLoc.hash)
	
	//window.event.returnValue=false;
	//history.forward()
		
	if(elementId!=null){
		getElement(elementId)
		layerHistory.push(currentElement);
		currentElement = elementId

		//marker knap
		if(document.getElementById(elementId+"Button")){
			if(currentButton!=null) document.getElementById(currentButton).className = "nonChoosen"
			currentButton = elementId+"Button"
			document.getElementById(elementId+"Button").className = "choosen"
			}
		}
		
		return false;
	}


	
	function goBack(){	
	//history.back();
	elementId = layerHistory.pop();	
	showElement(elementId);
	layerHistory.pop();	
	}
	

	

	
//AJAX stuff ////////////////////////////////	
function getElement(elementId)
{
	
xmlHttp=GetXmlHttpObject();

if (xmlHttp==null){
return
} 
url="ortfiles/"+elementId+".html";//?sid="+Math.random()
//alert(url)
xmlHttp.onreadystatechange=stateChanged 
xmlHttp.open("GET",url,true);
xmlHttp.send(null);
}


function stateChanged() {
	
	if(xmlHttp.readyState != 4) return
	if(xmlHttp.responseText == null) return;

var svar = xmlHttp.responseText;

document.getElementById("content").innerHTML = svar;
} 

function GetXmlHttpObject()
{ 
var objXMLHttp=null
if (window.XMLHttpRequest)
{
objXMLHttp=new XMLHttpRequest()
}
else if (window.ActiveXObject)
{
objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP")
}
return objXMLHttp
} 
