function varargout = project(varargin)

% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 26-Mar-2022 01:04:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before project is made visible.
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)
load covid_data;
global covid_data;
% global x variable is the type changing for the deaths or cases
global x;
x=3;
 global nondupp;
nondupp=nondup(covid_data);
global options;
options=2;
global slider;
slider=0;
global globaldataa
globaldataa=globaldata(covid_data);

set( handles.slider6, 'Min', 1, 'Max', 15, 'Value', 1 );
% Choose default command line output for project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in countries.
function countries_Callback(hObject, eventdata, handles)
% hObject    handle to countries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global covid_data;
global nondupp;
global x;
global slider;
global options;
global globaldataa;
country_index=get(handles.countries,'value');
key=nondupp(country_index);
data=searchdup(key,covid_data,1);
set(handles.states,'string',string(data(2:end,2)));
both=cell2mat(data(1,3:end));
if(country_index==1)
    key="Global";
    both=globaldataa;
end
cases=both(1,1:2:end);
deaths=both(1,2:2:end);
if (options==2)
        cases=daily(cases);
        deaths=daily(deaths);
        key=key+' ( Daily ) ';
end
if(slider~=0)
    cases =average(slider,cases);
    deaths=average(slider,deaths);
    key=key+num2str(slider)+'- Days Average';
end
 switch x
     case 1
         cla reset;
         bar(cases,'b');
         yyaxis left;
         xlim auto; 
         ylim auto;
         title("Cases "+key);
         x=1;
     case 2
         cla reset;
         plot(deaths,'r');
         yyaxis right;
         xlim auto; 
         ylim auto;
         title("Deaths "+key)
         x=2;
     otherwise  
         cla reset;
         bar(cases,'b');
         yyaxis left;
         hold on;
         yyaxis right;
         xlim auto; 
         ylim auto;
         plot(deaths,'r');
         title("Cases & Deaths "+key);
         x=3;
 end
% %     x=['Australian Capital Territory ' ,' New South Wales' ]
% %     for l=1:7;
% %     set(handles.states,'string','Australian Capital Territory ');
% %     end
%      set(handles.states,'string',x(11:19,1));
% end
% Hints: contents = cellstr(get(hObject,'String')) returns countries contents as cell array
%        contents{get(hObject,'Value')} returns selected item from countries


% --- Executes during object creation, after setting all properties.
function countries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to countries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in states.
function states_Callback(hObject, eventdata, handles)
% hObject    handle to states (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nondupp;
global x;
global slider;
global options;
global covid_data;
global globaldataa;
state_index=get(handles.states,'value');
con_index=get(handles.countries,'value'); 
key=nondupp(con_index);
datadup=searchdup(key,covid_data,1);
% dsip(x);
% x(state_index+1,2);
state_index=state_index+1;
key=key+" : "+datadup(state_index,2);
both=cell2mat(datadup(state_index ,3:end));
cases=both(1,1:2:end);
deaths=both(1,2:2:end);
if (options==2)
        cases=daily(cases);
        deaths=daily(deaths);
        key=key+' ( Daily ) ';
end
if(slider~=0)
    cases =average(slider,cases);
    deaths=average(slider,deaths);
    key=key+num2str(slider)+'- Days Average';
end
switch x
      case 1
          cla reset;
          bar(cases,'b');
          yyaxis left;
          xlim auto; 
         ylim auto;
         x=1;
          title("Cases "+key);
      case 2
          cla reset;
         plot(deaths,'r');
         yyaxis right;
         xlim auto; 
         ylim auto;
         x=2;
          title("Deaths "+key);
    otherwise 
        cla reset;
          bar(cases,'b');
          yyaxis left;
          hold on;
          yyaxis right;
          xlim auto; 
         ylim auto;
          plot(deaths,'r');
          x=3;      
          title("Cases & Deaths "+key);  
end
% Hints: contents = cellstr(get(hObject,'String')) returns states contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from states

% --- Executes during object creation, after setting all properties.
function states_CreateFcn(hObject, eventdata, handles)
% hObject    handle to states (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deaths.
function deaths_Callback(hObject, eventdata, handles)
% hObject    handle to deaths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
x=2;
% Hint: get(hObject,'Value') returns toggle state of deaths


% --- Executes on button press in both.
function both_Callback(hObject, eventdata, handles)
% hObject    handle to both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of both

% global x;
% x=3;
% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)


% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cases.
function cases_Callback(hObject, eventdata, handles)
% hObject    handle to cases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
x=1;
% Hint: get(hObject,'Value') returns toggle state of cases
% --- Executes on button press in cumulative.
function cumulative_Callback(hObject, eventdata, handles)
% hObject    handle to cumulative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global options;
options=1;
% Hint: get(hObject,'Value') returns toggle state of cumulative


% --- Executes on button press in daily.
function daily_Callback(hObject, eventdata, handles)
% hObject    handle to daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global options;
options=2;
% Hint: get(hObject,'Value') returns toggle state of daily


% --- Executes when selected object is changed in uibuttongroup5.
function uibuttongroup5_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup5 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global options 
global nondupp;
 global x;
 global covid_data;
 global slider;
 global globaldataa;
 country_index=get(handles.countries,'value');
 key=nondupp(country_index);
 data=searchdup(key,covid_data,1);
 state_index=get(handles.states,'value');
datadup=searchdup(key,covid_data,1);
if (size(datadup,1)>1)
  state_index=state_index+1;  
key=key+" "+datadup(state_index,2);
else 
    key=key+" "+datadup(1,2);
end 
 both=cell2mat(data(1,3:end));
 if(country_index==1)
    key="Global";
    both=globaldataa;
end
 cases=both(1,1:2:end);
 deaths=both(1,2:2:end);
 if (options==2)
        cases=daily(cases);
        deaths=daily(deaths);
        key=key+' ( Daily ) ';
        
 end
if(slider~=0)
    cases =average(slider,cases);
    deaths=average(slider,deaths);
    key=key+num2str(slider)+' - Days Average';
end
%  plot_data=get(eventdata.NewValue ,'Tag');
 switch get(eventdata.NewValue ,'Tag')
     case 'cases'
         cla reset;
         bar(cases,'b');
         ylim auto;
         yyaxis left;
         x=1;
         title("Cases "+key);
     case 'deaths'
         cla reset;
         plot(deaths,'r');
         xlim auto; 
         ylim auto;
         yyaxis right;
         x=2;
         title("Deaths "+key);
     otherwise
         cla reset;
         bar(cases,'b');
         x=3;
         yyaxis left;
         xlim auto; 
         ylim auto;
         hold on;
         yyaxis right;
         plot(deaths,'r');
         title("Cases & Deaths "+key);
 end


% --- Executes when selected object is changed in uibuttongroup6.
function uibuttongroup6_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup6 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global covid_data;
global nondupp;
global options;
global slider;
global globaldataa;
country_index=get(handles.countries,'value');
 key=nondupp(country_index);
 data=searchdup(key,covid_data,1);
 state_index=get(handles.states,'value');
datadup=searchdup(key,covid_data,1);
if (size(datadup,1)>1)
  state_index=state_index+1;  
key=key+" "+datadup(state_index,2);
else 
    key=key+" "+datadup(1,2);
end 
 both=cell2mat(data(1,3:end));
if(country_index==1)
    key="Global";
    both=globaldataa;
end
 cases=both(1,1:2:end);
 deaths=both(1,2:2:end);
ll=get(eventdata.NewValue ,'Tag');
if (strcmp(ll,'daily'))
        cases=daily(cases);
        deaths=daily(deaths);
        options=2;
        key=key+' ( Daily ) ';
end
if(slider~=0)
    cases =average(slider,cases);
    deaths=average(slider,deaths);
    key=key+num2str(slider)+' - Days Average';
end
switch x
     case 1
         cla reset;
         bar(cases,'b');
         yyaxis left;
         xlim auto; 
         ylim auto;
         title("Cases "+key);
         x=1;
     case 2
         cla reset;
         plot(deaths,'r');
         yyaxis right;
         xlim auto; 
         ylim auto;
         title("Deaths "+key)
         x=2;
     otherwise  
         cla reset;
         bar(cases,'b');
         yyaxis left;
         hold on;
         yyaxis right;
         xlim auto; 
         ylim auto;
         plot(deaths,'r');
         title("Cases & Deaths "+key);
         x=3;
 end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slider;
global nondupp;
global x;
global options;
global globaldataa;
global covid_data;
% uicontrol('Style','Slider','Min',1,'Max',15,'SliderStep',[1 2]);
% % set(handles.slider, 'Max',15, 'Value',1, 'Min',1) 
%  uicontrol('Style', 'Slider', ...
%            'SliderStep', [1/14, 0.1], ...
%            'Min', 1, 'Max', 15, 'Value', 1, ...
%            'Callback', @sliderCallback);
slider=round(10*get(handles.slider,'value'));
state_index=get(handles.states,'value');
con_index=get(handles.countries,'value'); 
key=nondupp(con_index);
datadup=searchdup(key,covid_data,1);
if (size(datadup,1)>1)
  state_index=state_index+1;  
key=key+" "+datadup(state_index,2);
else 
    key=key+" "+datadup(1,2);
    state_index=1;
end 
both=cell2mat(datadup(state_index ,3:end));
if(con_index==1)
    key="Global";
    both=globaldataa;
end
cases=both(1,1:2:end);
deaths=both(1,2:2:end);
if (options==2)
        cases=daily(cases);
        deaths=daily(deaths);
        key=key+' ( Daily ) ';
end
if(slider~=0)
    cases =average(slider,cases);
    deaths=average(slider,deaths);
    key=key+ num2str(slider) +' - Days Average';
end
switch x
      case 1
          cla reset;
          bar(cases,'b');
          yyaxis left;
          xlim auto; 
         ylim auto;
         x=1;
          title("Cases "+key);
      case 2
          cla reset;
         plot(deaths,'r');
         yyaxis right;
         xlim auto; 
         ylim auto;
         x=2;
          title("Deaths "+key);
    otherwise 
        cla reset;
          bar(cases,'b');
          yyaxis left;
          hold on;
          yyaxis right;
          xlim auto; 
         ylim auto;
          plot(deaths,'r');
          x=3;      
          title("Cases & Deaths "+key);  
end





function sliderCallback(hObject, EventData)
% Value = round(get(hObject, 'Value'));
% set(hObject, 'Value', Value);
% a=get(handles.slider,'value');
%  disp(a);
% state_index=get(handles.states,'value');
% con_index=get(handles.countries,'value'); 
% key=nondupp(con_index);
% datadup=searchdup(key,covid_data,1);
% % dsip(x);
% % x(state_index+1,2);
% state_index=state_index+1;
% key=key+" : "+datadup(state_index,2);
% both=cell2mat(datadup(state_index ,3:end));
% cases=both(1,1:2:end);
% deaths=both(1,2:2:end);
% if (options==2)
%         cases=daily(cases);
%         deaths=daily(deaths);
%         key=key+' ( Daily ) ';
% end
% if(slider~=1)
%     cases =average(slider,cases);
%     deaths=average(slider,deaths);
%     key=key+str(slider)+'- Days Average';
% end
% switch x
%       case 1
%           cla reset;
%           bar(cases,'b');
%           yyaxis left;
%           xlim auto; 
%          ylim auto;
%          x=1;
%           title("Cases "+key);
%       case 2
%           cla reset;
%          plot(deaths,'r');
%          yyaxis right;
%          xlim auto; 
%          ylim auto;
%          x=2;
%           title("Deaths "+key);
%     otherwise 
%         cla reset;
%           bar(cases,'b');
%           yyaxis left;
%           hold on;
%           yyaxis right;
%           xlim auto; 
%          ylim auto;
%           plot(deaths,'r');
%           x=3;      
%           title("Cases & Deaths "+key);  
% end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
