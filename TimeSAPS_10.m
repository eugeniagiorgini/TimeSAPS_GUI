classdef TimeSAPS_10 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        PatientsDisplayUIFigure     matlab.ui.Figure
        GridLayout                  matlab.ui.container.GridLayout
        LeftPanel                   matlab.ui.container.Panel
        LoadDataLabel               matlab.ui.control.Label
        TimeSAPSLabel               matlab.ui.control.Label
        TimeSeriesAnalysisforPersistentScatterersLabel  matlab.ui.control.Label
        StaMPSVelocityLabel         matlab.ui.control.Label
        StaMPSVelocityDropDown      matlab.ui.control.DropDown
        T1yEditFieldLabel           matlab.ui.control.Label
        T1yEditField                matlab.ui.control.NumericEditField
        FormatDropDownLabel         matlab.ui.control.Label
        FormatDropDown              matlab.ui.control.DropDown
        PSCodeEditFieldLabel        matlab.ui.control.Label
        PSCodeEditField             matlab.ui.control.NumericEditField
        CompareButton               matlab.ui.control.Button
        LoadButton                  matlab.ui.control.Button
        KnownPeriodsLabel           matlab.ui.control.Label
        EvaluateButton              matlab.ui.control.Button
        UnknownFrequenciesLabel     matlab.ui.control.Label
        FindButton                  matlab.ui.control.Button
        ExportDataLabel             matlab.ui.control.Label
        ExportButton                matlab.ui.control.Button
        PSOriginalvsModeledLabel    matlab.ui.control.Label
        T2yEditFieldLabel           matlab.ui.control.Label
        T2yEditField                matlab.ui.control.NumericEditField
        T3yEditFieldLabel           matlab.ui.control.Label
        T3yEditField                matlab.ui.control.NumericEditField
        T4yEditFieldLabel           matlab.ui.control.Label
        T4yEditField                matlab.ui.control.NumericEditField
        T5yEditFieldLabel           matlab.ui.control.Label
        T5yEditField                matlab.ui.control.NumericEditField
        DirectoryButton             matlab.ui.control.Button
        WorkDirectoryLabel          matlab.ui.control.Label
        WorkDirectoryEditField      matlab.ui.control.EditField
        PSOriginalvsLSModeledLabel  matlab.ui.control.Label
        PSCodeEditField_2Label      matlab.ui.control.Label
        NFrequenciesFind            matlab.ui.control.NumericEditField
        CompareButton_2             matlab.ui.control.Button
        LatminLabel                 matlab.ui.control.Label
        LatminEditField             matlab.ui.control.NumericEditField
        LatmaxEditFieldLabel        matlab.ui.control.Label
        LatmaxEditField             matlab.ui.control.NumericEditField
        LonminEditFieldLabel        matlab.ui.control.Label
        LonminEditField             matlab.ui.control.NumericEditField
        LonmaxEditFieldLabel        matlab.ui.control.Label
        LonmaxEditField             matlab.ui.control.NumericEditField
        SubsetLabel                 matlab.ui.control.Label
        GoButton                    matlab.ui.control.Button
        FrequencyFixedCheckBox      matlab.ui.control.CheckBox
        FindFrequenciesCheckBox     matlab.ui.control.CheckBox
        NFrequenciesEditFieldLabel  matlab.ui.control.Label
        NFrequenciesEditField       matlab.ui.control.NumericEditField
        RightPanel                  matlab.ui.container.Panel
        TabGroup                    matlab.ui.container.TabGroup
        LoadedDataTab               matlab.ui.container.Tab
        UIAxes3                     matlab.ui.control.UIAxes
        KnownPeriodsTab             matlab.ui.container.Tab
        PlotLabel                   matlab.ui.control.Label
        VariableDropDownLabel       matlab.ui.control.Label
        VariableDropDown            matlab.ui.control.DropDown
        PlotButton                  matlab.ui.control.Button
        UIAxes4                     matlab.ui.control.UIAxes
        KPPSComparisonTab           matlab.ui.container.Tab
        UITable4                    matlab.ui.control.Table
        UIAxes5                     matlab.ui.control.UIAxes
        UnknownFrequenciesTab       matlab.ui.container.Tab
        PlotButton_2                matlab.ui.control.Button
        VariableDropDown_2Label     matlab.ui.control.Label
        VariableDropDown_2          matlab.ui.control.DropDown
        PlotLabel_2                 matlab.ui.control.Label
        UIAxes6                     matlab.ui.control.UIAxes
        UFPSComparisonTab           matlab.ui.container.Tab
        UITable5                    matlab.ui.control.Table
        UIAxes8                     matlab.ui.control.UIAxes
        UIAxes7                     matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    properties (Access = public)
        lon
        lat
        ph_disp
        ph_mm
        ref_ps
        data
        lonlat
        day
        %FixedFrequencies
        m_k
        q_k
        u1_k
        u2_k
        a_k
        phi_k
        f_k
        signal_k
        line_k
        diff_k
        stdev_k
        model_k
        nf_k
        snr_k
        %Lomb-Scargle
        m_unk
        q_unk 
        u1_unk 
        u2_unk
        a_unk 
        phi_unk
        f_unk 
        m_det_unk 
        q_det_unk
        nf_unk
        signal_unk 
        line_unk 
        model_unk 
        diff_unk 
        stdev_unk
        detr_unk
        snr_unk
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.PatientsDisplayUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {612, 612};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {362, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
 
            clear app.ph_disp app.ph_mm app.data app.ref_ps app.lon app.lat app.lonlat app.day
            global ph_disp ph_mm data ref_ps lon lat lonlat day

            velocity_type=app.StaMPSVelocityDropDown.Value;
            
            [ps_plot_ts,ps_plot]=TSAPS_load_data(velocity_type);
            
            app.ph_disp=ps_plot.ph_disp;
            app.lonlat=ps_plot_ts.lonlat;
            app.lon=app.lonlat(:,1);
            app.lat=app.lonlat(:,2);
            app.ph_mm=ps_plot_ts.ph_mm;
            app.ref_ps=linspace(1,length(app.ph_disp),length(app.ph_disp));
            
            if isfield(ps_plot_ts,'data')
                app.data=ps_plot_ts.data;
            else
                app.day=ps_plot_ts.day;
                app.data=decyear(datevec(ps_plot_ts.day));
            end
            
            ph_mm=app.ph_mm;
            ph_disp=app.ph_disp;
            data=app.data;
            ref_ps=app.ref_ps;
            lonlat=app.lonlat;
            
            lon=app.lon;
            lat=app.lat;
            day=app.day;
            
            %Scatter3
            scatter(app.UIAxes3,lon,lat,30,app.ph_disp,'filled');
            title(app.UIAxes3, 'LOS velocity')
            cbar_3=colorbar(app.UIAxes3);
            cbar_3.Label.String='[mm/y]';
            
        end

        % Button pushed function: DirectoryButton
        function DirectoryButtonPushed(app, event)
            path=app.WorkDirectoryEditField.Value;
            cd(path);
        end

        % Button pushed function: EvaluateButton
        function EvaluateButtonPushed(app, event)
            
            clear m_k q_k u1_k u2_k a_k phi_k nf_k f_k lonlat signal_k line_k diff_k model_k stdev_k snr_k
            
            lon_fixed=app.lon;
            lat_fixed=app.lat;
            ref_ps_fixed=app.ref_ps;
            ph_mm_fixed=app.ph_mm;
            data_fixed=app.data;

            p1=app.T1yEditField.Value;
            p2=app.T2yEditField.Value;
            p3=app.T3yEditField.Value;
            p4=app.T4yEditField.Value;
            p5=app.T5yEditField.Value;
            
            % Period conversion in Frequencies
            [f_k_fixed,nf_k_fixed]=TSAPS_freq_conversion(p1,p2,p3,p4,p5);
            pippo=length(ph_mm_fixed(:,1));
            
            wtb_fixed_13= TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Known Periods 1/3: Finding Signals');

            
            m_k_fixed=zeros(pippo,1);
            q_k_fixed=zeros(pippo,1);
            
            
            if nf_k_fixed==0
                for i=1:pippo
                    [m_k_fixed(i),q_k_fixed(i)]=TSAPS_detrend_nofreq(data_fixed,ph_mm_fixed(i,:)',data_fixed(1));
                    u1_k_fixed=zeros(pippo,5);
                    u2_k_fixed=zeros(pippo,5);
                    a_k_fixed=zeros(pippo,5);
                    phi_k_fixed=zeros(pippo,5); 
                
                     wtb_fixed_13.Send;
                    pause(0.002);
                end
                wtb_fixed_13.Destroy
            else
                u1_k_fixed=zeros(pippo,nf_k_fixed);
                u2_k_fixed=zeros(pippo,nf_k_fixed);
                a_k_fixed=zeros(pippo,nf_k_fixed);
                phi_k_fixed=zeros(pippo,nf_k_fixed);
                
                for i=1:pippo
                    f_k_fixed(i,:)=f_k_fixed(1,:);
                    [m_k_fixed(i),q_k_fixed(i),u1_k_fixed(i,:),u2_k_fixed(i,:)] =TSAPS_freq_known(data_fixed,ph_mm_fixed(i,:)',data_fixed(1),nf_k_fixed,f_k_fixed(i,:));
                    [a_k_fixed(i,:),phi_k_fixed(i,:)]=TSAPS_amplitude_phase(u1_k_fixed(i,:),u2_k_fixed(i,:));
                    
                    
                    wtb_fixed_13.Send;
                    pause(0.002);
                end
                wtb_fixed_13.Destroy
            end

            %Signal recostruction
            signal_k_fixed=zeros(pippo,length(data_fixed));
            line_k_fixed=zeros(pippo,length(data_fixed));
            model_k_fixed=zeros(pippo,length(data_fixed));
            
            wtb_fixed_23= TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Known Periods 2/3: Model Evaluation');
            
            parfor i=1:pippo
                [signal_k_fixed(i,:),line_k_fixed(i,:),model_k_fixed(i,:)]=TSAPS_signal_recostruction(u1_k_fixed(i,:),u2_k_fixed(i,:),data_fixed,f_k_fixed(i,:),m_k_fixed(i),q_k_fixed(i),nf_k_fixed);
                wtb_fixed_23.Send;
                pause(0.002);
            end
            wtb_fixed_23.Destroy
            
            %Standar Deviation Evaluation
            wtb_fixed_33= TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Known Periods 2/3: Std and snr evaluation');

            parfor i=1:pippo
                [stdev_k_fixed(i,:),diff_k_fixed(i,:)]=TSAPS_signal_std(ph_mm_fixed(i,:),model_k_fixed(i,:));
                snr_k_fixed(i)=snr(ph_mm_fixed(i,:),(ph_mm_fixed(i,:)-model_k_fixed(i,:)));
                
                wtb_fixed_33.Send;
                pause(0.002);
            end
            wtb_fixed_33.Destroy
            

            
            app.f_k=f_k_fixed;
            app.nf_k=nf_k_fixed;
            app.m_k=m_k_fixed';
            app.q_k=q_k_fixed';
            app.u1_k=u1_k_fixed;
            app.u2_k=u2_k_fixed;   
            app.a_k=a_k_fixed;
            app.phi_k=phi_k_fixed;
            app.signal_k=signal_k_fixed;
            app.line_k=line_k_fixed;
            app.model_k=model_k_fixed;
            app.diff_k=diff_k_fixed;
            app.stdev_k=stdev_k_fixed;
            app.snr_k=snr_k_fixed;
             
            %Plot
            m_k_fixed=double(m_k_fixed);
            scatter_Fixed=scatter(app.UIAxes4,lon_fixed,lat_fixed,30,app.m_k','filled');
            title(app.UIAxes4, 'm')
            cbar_4=colorbar(app.UIAxes4);
            cbar_4.Label.String='[mm/y]';
            ps_row=dataTipTextRow('PS',ref_ps_fixed);
            scatter_Fixed.DataTipTemplate.DataTipRows(end+1) = ps_row;
            ps_row_2=dataTipTextRow('m',m_k_fixed,'%.2f');
            scatter_Fixed.DataTipTemplate.DataTipRows(end+1) = ps_row_2;
            
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            
            lon_plot=app.lonlat(:,1);
            lat_plot=app.lonlat(:,2);
            ref_ps_plot=app.ref_ps;
            
            m_k_plot=app.m_k;
            q_k_plot=app.q_k;
            f_k_plot=app.f_k;
            a_k_plot=app.a_k;
            phi_k_plot=app.phi_k;

            m_k_plot=m_k_plot';
            q_k_plot=q_k_plot';
            
            stdev_k_plot=app.stdev_k;
            
            snr_k_plot=app.snr_k;
            
            %Plot
            variable_FF=app.VariableDropDown.Value;
            [plot_4_FF,title_4,label_4]=TSAPS_plot_dropdown(variable_FF,m_k_plot,q_k_plot,stdev_k_plot,f_k_plot,a_k_plot,phi_k_plot,snr_k_plot);
            plot_4_FF=double(plot_4_FF);
 
            scatter_Fixed=scatter(app.UIAxes4,lon_plot,lat_plot,30,plot_4_FF,'filled');
            title(app.UIAxes4,title_4)
            cbar_4=colorbar(app.UIAxes4);
            cbar_4.Label.String=label_4; 
            ps_row=dataTipTextRow('PS',ref_ps_plot);
            scatter_Fixed.DataTipTemplate.DataTipRows(end+1) = ps_row;
            ps_row_2=dataTipTextRow('Value',plot_4_FF,'%.2f');
            scatter_Fixed.DataTipTemplate.DataTipRows(end+1) = ps_row_2;
            
        end

        % Button pushed function: GoButton
        function GoButtonPushed(app, event)
            global lon lat ref_ps ph_disp ph_mm lonlat
            
            lonlat_subset=app.lonlat;
            lon_subset=app.lon;
            lat_subset=app.lat;
            ref_ps_subset=app.ref_ps;
            ph_disp_subset=app.ph_disp;
            ph_mm_subset=app.ph_mm;
            
            lon_sub=[];
            lat_sub=[];
            ref_ps_sub=[];
            ph_disp_sub=[];
            ph_mm_sub=[];
            lonlat_sub=[];
            
            sub_lon_min=app.LonminEditField.Value;
            sub_lon_max=app.LonmaxEditField.Value;
            sub_lat_min=app.LatminEditField.Value;
            sub_lat_max=app.LatmaxEditField.Value;
            
            wtb_subset=waitbar(0,'Progress: 0 %','Name','Subset','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            setappdata(wtb_subset,'canceling',0);
                       
            pippo=length(ph_mm_subset(:,1));
            
            k=1;
            for i=1:pippo
                if (lon_subset(i,1)>sub_lon_min && lon_subset(i,1)<sub_lon_max && lat_subset(i,1)>sub_lat_min && lat_subset(i,1)<sub_lat_max)
                    lon_sub(k,1)=lon_subset(i,1);
                    lat_sub(k,1)=lat_subset(i,1);
                    ref_ps_sub(k)=ref_ps_subset(i);
                    ph_disp_sub(k,1)=ph_disp_subset(i,1);
                    ph_mm_sub(k,:)=ph_mm_subset(i,:);
                    lonlat_sub(k,:)=lonlat_subset(i,:); 
                    k=k+1;
                end
                if getappdata(wtb_subset,'canceling')
                    break
                end
                waitbar(i/pippo,wtb_subset,sprintf('Progress: %3.1f %',i/pippo*100))
            end
            
            delete(wtb_subset)
            
            scatter(app.UIAxes3,lon_sub,lat_sub,30,ph_disp_sub,'filled');
           
            lon=lon_sub;
            lat=lat_sub;
            ref_ps=ref_ps_sub;
            ph_disp=ph_disp_sub;
            ph_mm=ph_mm_sub;
            lonlat=lonlat_sub;
            
            app.lon=lon_sub;
            app.lat=lat_sub;
            app.lonlat=lonlat_sub;
            app.ref_ps=ref_ps_sub;
            app.ph_disp=ph_disp_sub;
            app.ph_mm=ph_mm_sub;
           
        end

        % Button pushed function: CompareButton
        function CompareButtonPushed(app, event)
            
            cla(app.UIAxes5,'reset')
            
            lon_compare=app.lonlat(:,1);
            lat_compare=app.lonlat(:,2);
            ref_ps_compare=app.ref_ps;
            ph_mm_compare=app.ph_mm;
            data_compare=app.data;
            model_k_compare=app.model_k;
            f_k_compare=app.f_k;
            nf_k_compare=app.nf_k;
            a_k_compare=app.a_k;
            phi_k_compare=app.phi_k;
            m_k_compare=app.m_k;
            q_k_compare=app.q_k;
            stdev_k_compare=app.stdev_k;
            
            snr_k_compare=app.snr_k;
            
            PS_number=app.PSCodeEditField.Value;
            PS_code=find(ref_ps_compare==PS_number);
            
            %Plot
            scatter(app.UIAxes5,data_compare,ph_mm_compare(PS_code,:),'filled','SizeData',20);
            hold(app.UIAxes5,"on"); 
            scatter(app.UIAxes5,data_compare,model_k_compare(PS_code,:),'filled','SizeData',10);
            title(app.UIAxes5,'Time Series comparison: Original vs Modeled');
            legend(app.UIAxes5,'PS Original','PS Modeled');
            app.UIAxes5.XLabel.String='Period [y]';
            app.UIAxes5.YLabel.String='Displacement [mm]';
            
            %Table
            [data4table_t4]=TSAPS_table_update_ps(ref_ps_compare,lon_compare,lat_compare,m_k_compare,q_k_compare,stdev_k_compare,a_k_compare,phi_k_compare,f_k_compare,nf_k_compare,PS_code,snr_k_compare);

            table2dataOLD_t4=table(data4table_t4);
            table2data_t4=splitvars(table2dataOLD_t4);
            table2data_t4.Properties.VariableNames={'Ref_PS','lon','lat','m','q','st_dev','SNR','f1','f1-A','f1-phi','f2','f2-A','f2-phi','f3','f3-A','f3-phi','f4','f4-A','f4-phi','f5','f5-A','f5-phi'};
            app.UITable4.Data=(table2data_t4);
        end

        % Button pushed function: FindButton
        function FindButtonPushed(app, event)
            
            clear m_det_unk_find q_det_unk_find m_unk_temp q_unk_temp f_unk u1_unk u2_unk a_unk phi_unk nf_unk m_unk q_unk line_unk signal_unk diff_unk model_unk stdev_unk detr_unk
            
            %1. Check frequencies number
            nf_unk_find=app.NFrequenciesEditField.Value;
            nf_unk_find=int8(nf_unk_find);
            if isinteger(nf_unk_find)
            
                lon_find=app.lonlat(:,1);
                lat_find=app.lonlat(:,2);
                ref_ps_find=app.ref_ps;
                ph_mm_find=app.ph_mm;
                data_find=app.data;
               
                
                pippo=length(ph_mm_find(:,1));
                pluto=length(data_find);
            
                wtb_find_15 = TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Find Frequency 1/5: Detrending Series');
                parfor kk=1:pippo
                    [m_det_unk_find(kk),q_det_unk_find(kk),detr_unk_find(kk,:)]=TSAPS_detrend(ph_mm_find(kk,:)',data_find);
                    wtb_find_15.Send;
                    pause(0.002);
                end
                wtb_find_15.Destroy
            
                ph_mm_det_temp=detr_unk_find;

                %Check frequencies
            
                if (nf_unk_find ~= 0)
                    u1_unk_find=zeros(pippo,nf_unk_find);
                    u2_unk_find=zeros(pippo,nf_unk_find);
                    f_unk_find=zeros(pippo,nf_unk_find);
                    
                    wtb_find_25 = TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Find Frequency 2/5: Finding Frequencies');
        
                    %2. Lomb Scargle
                    
                    parfor i=1:pippo
                        [m_unk_find(i),q_unk_find(i),u1_unk_find(i,:),u2_unk_find(i,:),f_unk_find(i,:),signal_unk_find(i,:),line_unk_find(i,:),model_unk_find(i,:)] = TSAPS_find_signals(nf_unk_find,ph_mm_det_temp(i,:),ph_mm_find(i,:),data_find);
                        wtb_find_25.Send;
                        pause(0.002);
                    end
                    wtb_find_25.Destroy
               
                    
                    
                    parfor i=1:pippo
                        if m_unk_find(i)==0
                            for j=1:pluto
                              line_unk_find(i,j)=q_det_unk_find(i)+m_det_unk_find(i)*(data_find(j)-data_find(1));
                            end
                        else
                            m_det_unk_find(i)=m_unk_find(i);
                            q_det_unk_find(i)=q_unk_find(i);
                        end
                    end
    
                else
                    line_unk_find=zeros(pippo,pluto);
                    
                    wtb_find_35=waitbar(0,'Progress: 0 %','Name','Find Frequency 2/5: Fitting Models');
                    
                    for j=1:pippo
                        for k=1:pluto
                            line_unk_find(j,k)=q_det_unk_find(j)+m_det_unk_find(j)*(data_find(k)-data_find(1));
                        end
                         waitbar(j/pippo,wtb_find_35,sprintf('Progress: %3.1f %%',i/pippo*100))
                    end
                    delete(wtb_find_35)
    
                    
                end                      
               
                wtb_find_45 = TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Find Frequency 3/5: Signal Recostruction');
                parfor i=1:pippo
                    [a_unk_find(i,:),phi_unk_find(i,:)] =TSAPS_amplitude_phase(u1_unk_find(i,:),u2_unk_find(i,:));
                    wtb_find_45.Send;
                    pause(0.002);
                end
                wtb_find_45.Destroy
                
                wtb_find_55 = TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Find Frequency 4/5: Standard Deviation');
                
                parfor i=1:pippo
                    [stdev_unk_find(i,:),diff_unk_find(i,:)] =TSAPS_signal_std(ph_mm_find(i,:),model_unk_find(i,:));
                    wtb_find_55.Send;
                    pause(0.002);
                end
                
                wtb_find_55.Destroy

                wtb_find_65 = TSAPS_parfor_wait(pippo, 'Waitbar', true,'Title', 'Find Frequency 5/5: SNR Evaluation');
                
                parfor i=1:pippo
                    snr_unk_find(i)=snr(ph_mm_find(i,:),(ph_mm_find(i,:)-model_unk_find(i,:)));
                    wtb_find_65.Send;
                    pause(0.002);
                end
                
                wtb_find_65.Destroy

                app.a_unk=a_unk_find;
                app.phi_unk=phi_unk_find;
                app.nf_unk=nf_unk_find;
                app.f_unk=f_unk_find;
                app.m_det_unk=m_det_unk_find;
                app.q_det_unk=q_det_unk_find; 
                app.signal_unk=signal_unk_find;
                app.line_unk=line_unk_find;
                app.model_unk=model_unk_find;
                app.diff_unk=diff_unk_find;
                app.stdev_unk=stdev_unk_find;
                app.detr_unk=detr_unk_find;
                app.snr_unk=snr_unk_find;
                                
                app.m_unk=m_det_unk_find;
                app.q_unk=q_det_unk_find;
                app.u1_unk=u1_unk_find;
                app.u2_unk=u2_unk_find;
                app.f_unk=f_unk_find;
                
                %Plot
                scatter_Find=scatter(app.UIAxes6,lon_find,lat_find,30,m_det_unk_find','filled');
                title(app.UIAxes6, 'm')
                cbar_6=colorbar(app.UIAxes6);
                cbar_6.Label.String='[mm/y]';
                ps_row=dataTipTextRow('PS',ref_ps_find);
                scatter_Find.DataTipTemplate.DataTipRows(end+1) = ps_row;
            
            else
                errordlg('Insert an integer number!','Find Frequency Error');
            end
            
        end

        % Button pushed function: CompareButton_2
        function CompareButton_2Pushed(app, event)
            
            cla(app.UIAxes7,'reset')
            cla(app.UIAxes8,'reset')
            
            lon_compare=app.lonlat(:,1);
            lat_compare=app.lonlat(:,2);
            ref_ps_compare=app.ref_ps;
            ph_mm_compare=app.ph_mm;
            data_compare=app.data;
            model_unk_compare=app.model_unk;
            a_unk_compare=app.a_unk;
            phi_unk_compare=app.phi_unk;
            m_unk_compare=app.m_unk;
            q_unk_compare=app.q_unk;
            f_unk_compare=app.f_unk;
            stdev_unk_compare=app.stdev_unk;
            nf_unk_compare=app.nf_unk;
            detr_unk_compare=app.detr_unk;
            
            PS_number=app.NFrequenciesFind.Value;
            PS_code=find(ref_ps_compare==PS_number);
            
            snr_unk_compare=app.snr_unk;
            
            [~,pxx_compare,~,f1_ls_compare,~]=TSAPS_lomb_scargle(detr_unk_compare(PS_code,:)',data_compare,nf_unk_compare);

            
            %Plot
            scatter(app.UIAxes7,data_compare,ph_mm_compare(PS_code,:),'filled','SizeData',20);
            hold(app.UIAxes7,"on"); 
            scatter(app.UIAxes7,data_compare,model_unk_compare(PS_code,:),'filled','SizeData',10);
            title(app.UIAxes7,'Time Series comparison: Original vs Modeled');
            legend(app.UIAxes7,'PS Original','PS Modeled');
            app.UIAxes7.XLabel.String='Period [y]';
            app.UIAxes7.YLabel.String='Displacement [mm]';
            
            %Table
            [data4table_t5]=TSAPS_table_update_ps(ref_ps_compare,lon_compare,lat_compare,m_unk_compare,q_unk_compare,stdev_unk_compare,a_unk_compare,phi_unk_compare,f_unk_compare,nf_unk_compare,PS_code,snr_unk_compare);

            table2dataOLD_t5=table(data4table_t5);
            table2data_t5=splitvars(table2dataOLD_t5);
            table2data_t5.Properties.VariableNames={'Ref_PS','lon','lat','m','q','st_dev','SNR','f1','f1-A','f1-phi','f2','f2-A','f2-phi','f3','f3-A','f3-phi','f4','f4-A','f4-phi','f5','f5-A','f5-phi'};
            app.UITable5.Data=(table2data_t5);
            
            %Power Spectrum
            plot(app.UIAxes8,f1_ls_compare,pxx_compare,'LineWidth',3);
            title(app.UIAxes8,'Lomb Scargle Periodogram');
            legend(app.UIAxes8,'Power Spectrum');
            xaxses_8=0:2:12;
            app.UIAxes8.XTick=xaxses_8;
            app.UIAxes8.XLabel.String='Frequency [1/y]';
            app.UIAxes8.YLabel.String='Spectral Density';
            
        end

        % Button pushed function: PlotButton_2
        function PlotButton_2Pushed(app, event)
            

            lon_plot=app.lonlat(:,1);
            lat_plot=app.lonlat(:,2);
            ref_ps_plot=app.ref_ps;
            
            m_unk_plot=app.m_unk;
            q_unk_plot=app.q_unk;
            a_unk_plot=app.a_unk;
            phi_unk_plot=app.phi_unk;
            f_unk_plot=app.f_unk;
            stdev_unk_plot=app.stdev_unk;
            
            snr_unk_plot=app.snr_unk;
            
            m_unk_plot=m_unk_plot';
            q_unk_plot=q_unk_plot';
           
            %Plot
            variable_plot_FF=app.VariableDropDown_2.Value;
            [plot_6_FF,title_6,label_6]=TSAPS_plot_dropdown(variable_plot_FF,m_unk_plot,q_unk_plot,stdev_unk_plot,f_unk_plot,a_unk_plot,phi_unk_plot,snr_unk_plot);

            plot_6_FF=double(plot_6_FF);
            
            scatter_Find=scatter(app.UIAxes6,lon_plot,lat_plot,30,plot_6_FF,'filled');
            title(app.UIAxes6,title_6)
            cbar_6=colorbar(app.UIAxes6);
            cbar_6.Label.String=label_6;
            ps_row=dataTipTextRow('PS',ref_ps_plot);
            scatter_Find.DataTipTemplate.DataTipRows(end+1) = ps_row;
            ps_row_2=dataTipTextRow('Value',plot_6_FF,'%.2f');
            scatter_Find.DataTipTemplate.DataTipRows(end+1) = ps_row_2;
                
            
            
            
        end

        % Button pushed function: ExportButton
        function ExportButtonPushed(app, event)
            lonlat_export=app.lonlat;
            lon_export=app.lonlat(:,1);
            lat_export=app.lonlat(:,2);
            ref_ps_export=app.ref_ps;
            ph_disp_export=app.ph_disp;
            ph_mm_export=app.ph_mm;
            data_export=app.data;
            day_export=app.day;
            
            model_k_export=app.model_k;
            u1_k_export=app.u1_k;
            u2_k_export=app.u2_k;
            a_k_export=app.a_k;
            phi_k_export=app.phi_k;
            m_k_export=app.m_k;
            q_k_export=app.q_k;
            stdev_k_export=app.stdev_k;
            f_k_export=app.f_k;
            nf_k_export=app.nf_k;
            snr_k_export=app.snr_k;

            model_unk_export=app.model_unk;
            u1_unk_export=app.u1_unk;
            u2_unk_export=app.u2_unk;
            a_unk_export=app.a_unk;
            phi_unk_export=app.phi_unk;
            m_unk_export=app.m_unk;
            q_unk_export=app.q_unk;
            f_unk_export=app.f_unk;
            stdev_unk_export=app.stdev_unk;
            nf_unk_export=app.nf_unk;
            snr_unk_export=app.snr_unk;
            
            ref_ps_export=ref_ps_export';
            m_k_export=m_k_export';
            q_k_export=q_k_export';
            stdev_k_export=stdev_k_export';
            stdev_unk_export=stdev_unk_export';
            
            format=app.FormatDropDown.Value;
            check_fixed=app.FrequencyFixedCheckBox.Value;
            check_find=app.FindFrequenciesCheckBox.Value;
            
            if isempty(u1_unk_export)
                u1_unk_export=zeros(length(ph_mm_export(:,1)),5);
                u2_unk_export=zeros(length(ph_mm_export(:,1)),5);
                a_unk_export=zeros(length(ph_mm_export(:,1)),5);
                f_unk_export=zeros(length(ph_mm_export(:,1)),5);
                m_unk_export=zeros(length(ph_mm_export(:,1)),1)';
                q_unk_export=zeros(length(ph_mm_export(:,1)),1)';
                phi_unk_export=zeros(length(ph_mm_export(:,1)),5);
                stdev_unk_export=zeros(length(ph_mm_export(:,1)),1);
                model_unk_export=zeros(length(ph_mm_export(:,1)),length(data_export));
            end

            if isempty(u1_k_export)
                u1_k_export=zeros(length(ph_mm_export(:,1)),5);
                u2_k_export=zeros(length(ph_mm_export(:,1)),5);
                a_k_export=zeros(length(ph_mm_export(:,1)),5);
                m_k_export=zeros(length(ph_mm_export(:,1)),1)';
                q_k_export=zeros(length(ph_mm_export(:,1)),1)';
                f_k_export=zeros(length(ph_mm_export(:,1)),5);
                phi_k_export=zeros(length(ph_mm_export(:,1)),5);
                stdev_k_export=zeros(length(ph_mm_export(:,1)),1);
                model_k_export=zeros(length(ph_mm_export(:,1)),length(data_export));
            end
         
            %ExportFile
            switch(format)
                case{'csv'}
                     wtb_export_csv=waitbar(1/3,'Exporting .csv files','Name','Export');

                    if (check_fixed==1)
                        %FreqFixed - fixed - csv            
                        [export_tab_fixed]=TSAPS_export_tab(ref_ps_export,lonlat_export,m_k_export,q_k_export,stdev_k_export,snr_k_export);
                        export_tab_table_old_fixed=table(export_tab_fixed);
                        export_tab_table_fixed=splitvars(export_tab_table_old_fixed);
                        export_tab_table_fixed.Properties.VariableNames={'ref_ps_export','lon_export','lat_export','m','q','st_dev','SNR'};

                        filename_fixed_1_csv='TimeSAPS_known_periods_Data.csv';
                        writetable(export_tab_table_fixed,filename_fixed_1_csv);
                        
                        export_tab_fixed_serie=model_k_export;
                        
                        filename_fixed_2_csv='TimeSAPS_known_periods_TS_Models.csv';
                        csvwrite(filename_fixed_2_csv,export_tab_fixed_serie);
                        
                        writematrix(f_k_export,'TimeSAPS_known_periods_Frequecies.csv','Delimiter','tab');
                        writematrix(a_k_export,'TimeSAPS_known_periods_Amplitudes.csv','Delimiter','tab');
                        writematrix(phi_k_export,'TimeSAPS_known_periods_Phases.csv','Delimiter','tab');
                                                
                    end
                    waitbar(2/3,wtb_export_csv,sprintf('Exporting .csv files'));
                    if (check_find==1)
                        %FindFrequencies - find - csv
                        [export_tab_find]=TSAPS_export_tab(ref_ps_export,lonlat_export,m_unk_export,q_unk_export,stdev_unk_export,snr_unk_export);
                        export_tab_table_old_find=table(export_tab_find);
                        export_tab_table_find=splitvars(export_tab_table_old_find);
                        export_tab_table_find.Properties.VariableNames={'ref_ps_export','lon_export','lat_export','m','q','st_dev','SNR'};

                        filename_find_1_csv='TimeSAPS_unknown_frequencies_Data.csv';
                        writetable(export_tab_table_find,filename_find_1_csv);
                        
                        export_tab_find_serie=model_unk_export;
                        
                        filename_find_2_csv='TimeSAPS_unknown_frequencies_TS_Models.csv';                        
                        csvwrite(filename_find_2_csv,export_tab_find_serie);
                        
                        writematrix(f_unk_export,'TimeSAPS_unknown_frequencies_Frequecies.csv','Delimiter','tab');
                        writematrix(a_unk_export,'TimeSAPS_unknown_frequencies_Amplitudes.csv','Delimiter','tab');
                        writematrix(phi_unk_export,'TimeSAPS_unknown_frequencies_Phases.csv','Delimiter','tab');
              
                    end
                    
                    waitbar(3/3,wtb_export_csv,sprintf('Done!'));
                    
                case{'shp'}
                    wtb_export_shp=waitbar(1/3,'Exporting .shp files','Name','Export');
                    if (check_fixed==1)
                        shp=1;
                        %Frequency Fixed - Shape 1 - Data
                        shape_fixed_1=TSAPS_3_shape_data(lon_export,lat_export,ref_ps_export,m_k_export,q_k_export,stdev_k_export,a_k_export,phi_k_export,f_k_export,nf_k_export);
            
                        filename_fixed_1_shp='TimeSAPS_FreqFx_Data.shp';
                        shapewrite(shape_fixed_1,filename_fixed_1_shp);
                        
                        %Frequency Fixed - Shape 2 - Models
                        shape_fixed_2=TSAPS_3_shape_serie(day_export,lon_export,lat_export,ref_ps_export,m_k_export,stdev_k_export,model_k_export,shp);
                        
                        filename_fixed_2_shp='TimeSAPS_FreqFx_TS_Models.shp';
                        shapewrite(shape_fixed_2,filename_fixed_2_shp);
                    end
                    waitbar(2/3,wtb_export_shp,sprintf('Exporting .shp files'));
                    if (check_find==1)
                        shp=2;
                        %Find Frequencies - Shape 1 - Signals
                        [shape_find_1]=TSAPS_shape_data(lon_export,lat_export,ref_ps_export,m_unk_export,q_unk_export,stdev_unk_export,a_unk_export,phi_unk_export,f_unk_export,nf_unk_export);
            
                        filename_find_1_shp='TimeSAPS_unknown_frequencies_Data.shp';
                        shapewrite(shape_find_1,filename_find_1_shp);
                        
                        %Find Frequencies - Shape 2 - Models
                        [shape_find_2]=TSAPS_shape_serie(day_export,lon_export,lat_export,ref_ps_export,m_unk_export,stdev_unk_export,model_unk_export,shp);
                        
                        filename_find_2_shp='TimeSAPS_unknown_frequencies_TS_Models.shp';
                        shapewrite(shape_find_2,filename_find_2_shp);
                    end
                    
                     waitbar(3/3,wtb_export_shp,sprintf('Done!'));
                
                case{'mat'}
                    wtb_export_mat=waitbar(1/3,'Exporting .mat files','Name','Export');
                    if (check_fixed==1)
                        filename_fixed_1_mat='TimeSAPS_known_periods_Data.mat';
                        save(filename_fixed_1_mat,'lonlat_export','ref_ps_export','ph_disp_export','ph_mm_export','data_export','day_export','u1_k_export','u2_k_export','a_k_export','phi_k_export','m_k_export','q_k_export','stdev_k_export','f_k_export','snr_k_export');
                        
                        filename_fixed_2_mat='TimeSAPS_known_periods_TS_Models.mat';
                        save(filename_fixed_2_mat,'ref_ps_export','data_export','day_export','model_k_export','ph_mm_export');
                    end
                    waitbar(2/3,wtb_export_mat,sprintf('Exporting .mat files'));
                    if (check_find==1)
                        filename_find_1_mat='TimeSAPS_FindFind_Data.mat';
                        save(filename_find_1_mat,'lonlat_export','ref_ps_export','ph_disp_export','ph_mm_export','data_export','day_export','u1_unk_export','u2_unk_export','a_unk_export','phi_unk_export','m_unk_export','q_unk_export','f_unk_export','stdev_unk_export','nf_unk_export','snr_unk_export');
                        
                        filename_find_2_mat='TimeSAPS_FindFind_TS_Models.mat';
                        save(filename_find_2_mat,'ref_ps_export','data_export','day_export','ph_mm_export','model_unk_export');
                    end
                    
                   waitbar(3/3,wtb_export_mat,sprintf('Done!'));
            end                   
            
        end

        % Callback function
        function GeoplotButtonPushed(app, event)
            
            ph_mm_gep=app.ph_mm;
            ph_disp_gep=app.ph_disp;
            data_gep=app.data;
            ref_ps_gep=app.ref_ps;
            lonlat_gep=app.lonlat;
            
            lon_gep=app.lon;
            lat_gep=app.lat;
            day_gep=app.day;
            
            for i=1:length(lon_gep(:,1))
                [xEast(i,1),yNorth(i,1)] =latlon2local(lat_gep(i),lonlat_gep(i),0,[0,0,0]);
            end
            
            %Figure
            figure
            geoscatter(xEast(:,2),yNorth(:,1),30,ph_disp_gep,'filled')
            title('LOS Velocity')
            cbar_geos_load=colorbar;
            cbar_geos_load.Label.String="[mm/y]";
            
        end

        % Callback function
        function GeoplotButton_2Pushed(app, event)
            global lon lat ref_ps ph_disp ph_mm data m_k q_k f_k a_k phi_k u1_k u2_k lonlat stdev_k
            
            lonlat=app.lonlat;
            lon=app.lonlat(:,1);
            lat=app.lonlat(:,2);
            ref_ps=app.ref_ps;
            ph_disp=app.ph_disp;
            ph_mm=app.ph_mm;
            data=app.data;
            
            
            m_k=app.m_k;
            q_k=app.q_k;
            u1_k=app.u1_k;
            u2_k=app.u2_k;
            f_k=app.f_k;
            a_k=app.a_k;
            phi_k=app.phi_k;
            
            check_length=length(u1_k(1,:));
            if (check_length ~= 5)
                    u1_k(:,(check_length+1):5)=0;
                    u2_k(:,(check_length+1):5)=0;
            end
            
            m_k=m_k';
            q_k=q_k';
            
            stdev_k=app.stdev_k;
            
            %Fare il Grafico
            variable_plot_FF=app.VariableDropDown.Value;
            
            [plot_4_FF,title_4,label_4]=TSAPS_2_plot_dropdown(variable_plot_FF,m_k,q_k,stdev_k,f_k,a_k,phi_k);

            %Grafico
            figure
            geoscatter(lonlat(:,2),lonlat(:,1),30,plot_4_FF,'filled');
            title(title_4)
            cbar_geos_fixed=colorbar;
            cbar_geos_fixed.Label.String=label_4;
        end

        % Callback function
        function GeoplotButton_3Pushed(app, event)
            global lon lat ref_ps ph_disp ph_mm data lonlat m_unk q_unk u1_unk u2_unk f_unk stdev_unk a_unk phi_unk
            
            lonlat=app.lonlat;
            lon=app.lonlat(:,1);
            lat=app.lonlat(:,2);
            ref_ps=app.ref_ps;
            ph_disp=app.ph_disp;
            ph_mm=app.ph_mm;
            data=app.data;
            
            m_unk=app.m_unk;
            q_unk=app.q_unk;
            u1_unk=app.u1_unk;
            u2_unk=app.u2_unk;
            a_unk=app.a_unk;
            phi_unk=app.phi_unk;
            f_unk=app.f_unk;
            stdev_unk=app.stdev_unk;
            
            m_unk=m_unk';
            q_unk=q_unk';
           
            %Fare il Grafico
            variable_plot_FF=app.VariableDropDown_2.Value;
            
            [plot_6_FF,title_6,label_6] =TSAPS_plot_dropdown(variable_plot_FF,m_unk,q_unk,stdev_unk,f_unk,a_unk,phi_unk);

            %Grafico
            figure
            geoscatter(lonlat(:,2),lonlat(:,1),30,plot_6_FF,'filled');
            title(title_6)
            cbar_geos_find=colorbar;
            cbar_geos_find.Label.String=label_6;
        end

        % Value changed function: NFrequenciesFind
        function NFrequenciesFindValueChanged(app, event)

            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PatientsDisplayUIFigure and hide until all components are created
            app.PatientsDisplayUIFigure = uifigure('Visible', 'off');
            app.PatientsDisplayUIFigure.AutoResizeChildren = 'off';
            app.PatientsDisplayUIFigure.Position = [100 100 967 612];
            app.PatientsDisplayUIFigure.Name = 'Patients Display';
            app.PatientsDisplayUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.PatientsDisplayUIFigure);
            app.GridLayout.ColumnWidth = {362, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.BackgroundColor = [1 1 1];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;
            app.LeftPanel.Scrollable = 'on';

            % Create LoadDataLabel
            app.LoadDataLabel = uilabel(app.LeftPanel);
            app.LoadDataLabel.FontSize = 16;
            app.LoadDataLabel.FontWeight = 'bold';
            app.LoadDataLabel.FontColor = [0 0 0.5608];
            app.LoadDataLabel.Position = [7 569 83 22];
            app.LoadDataLabel.Text = 'Load Data';

            % Create TimeSAPSLabel
            app.TimeSAPSLabel = uilabel(app.LeftPanel);
            app.TimeSAPSLabel.HorizontalAlignment = 'center';
            app.TimeSAPSLabel.FontSize = 25;
            app.TimeSAPSLabel.FontWeight = 'bold';
            app.TimeSAPSLabel.FontColor = [0 0 0.5608];
            app.TimeSAPSLabel.Position = [126 617 131 31];
            app.TimeSAPSLabel.Text = {'TimeSAPS'; ''};

            % Create TimeSeriesAnalysisforPersistentScatterersLabel
            app.TimeSeriesAnalysisforPersistentScatterersLabel = uilabel(app.LeftPanel);
            app.TimeSeriesAnalysisforPersistentScatterersLabel.HorizontalAlignment = 'center';
            app.TimeSeriesAnalysisforPersistentScatterersLabel.FontWeight = 'bold';
            app.TimeSeriesAnalysisforPersistentScatterersLabel.FontAngle = 'italic';
            app.TimeSeriesAnalysisforPersistentScatterersLabel.FontColor = [0.0118 0.3294 0.9098];
            app.TimeSeriesAnalysisforPersistentScatterersLabel.Position = [56 596 271 22];
            app.TimeSeriesAnalysisforPersistentScatterersLabel.Text = 'Time Series Analysis for Persistent Scatterers';

            % Create StaMPSVelocityLabel
            app.StaMPSVelocityLabel = uilabel(app.LeftPanel);
            app.StaMPSVelocityLabel.FontWeight = 'bold';
            app.StaMPSVelocityLabel.FontColor = [0.0118 0.3294 0.9098];
            app.StaMPSVelocityLabel.Position = [7 494 111 28];
            app.StaMPSVelocityLabel.Text = {'StaMPS Velocity'; ''};

            % Create StaMPSVelocityDropDown
            app.StaMPSVelocityDropDown = uidropdown(app.LeftPanel);
            app.StaMPSVelocityDropDown.Items = {'v', 'v-a', 'v-d', 'v-o', 'v-s', 'v-ao', 'v-da', 'v-do', 'v-ds', 'v-so', 'v-dai', 'v-dait', 'v-dao', 'v-dso'};
            app.StaMPSVelocityDropDown.FontColor = [0 0.149 1];
            app.StaMPSVelocityDropDown.Position = [109 495 161 27];
            app.StaMPSVelocityDropDown.Value = 'v';

            % Create T1yEditFieldLabel
            app.T1yEditFieldLabel = uilabel(app.LeftPanel);
            app.T1yEditFieldLabel.HorizontalAlignment = 'right';
            app.T1yEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.T1yEditFieldLabel.Position = [71 377 36 22];
            app.T1yEditFieldLabel.Text = 'T1 [y]';

            % Create T1yEditField
            app.T1yEditField = uieditfield(app.LeftPanel, 'numeric');
            app.T1yEditField.FontColor = [0.0118 0.3294 0.9098];
            app.T1yEditField.Position = [64 346 49 29];

            % Create FormatDropDownLabel
            app.FormatDropDownLabel = uilabel(app.LeftPanel);
            app.FormatDropDownLabel.FontWeight = 'bold';
            app.FormatDropDownLabel.FontColor = [0.0118 0.3294 0.9098];
            app.FormatDropDownLabel.Position = [7 46 65 22];
            app.FormatDropDownLabel.Text = 'Format';

            % Create FormatDropDown
            app.FormatDropDown = uidropdown(app.LeftPanel);
            app.FormatDropDown.Items = {'csv', 'shp', 'mat'};
            app.FormatDropDown.FontColor = [0.0118 0.3294 0.9098];
            app.FormatDropDown.Position = [64 45 52 24];
            app.FormatDropDown.Value = 'csv';

            % Create PSCodeEditFieldLabel
            app.PSCodeEditFieldLabel = uilabel(app.LeftPanel);
            app.PSCodeEditFieldLabel.FontWeight = 'bold';
            app.PSCodeEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.PSCodeEditFieldLabel.Position = [7 256 55 22];
            app.PSCodeEditFieldLabel.Text = 'PS Code';

            % Create PSCodeEditField
            app.PSCodeEditField = uieditfield(app.LeftPanel, 'numeric');
            app.PSCodeEditField.HorizontalAlignment = 'left';
            app.PSCodeEditField.FontWeight = 'bold';
            app.PSCodeEditField.FontColor = [0.0118 0.3294 0.9098];
            app.PSCodeEditField.Position = [77 253 141 29];

            % Create CompareButton
            app.CompareButton = uibutton(app.LeftPanel, 'push');
            app.CompareButton.ButtonPushedFcn = createCallbackFcn(app, @CompareButtonPushed, true);
            app.CompareButton.FontWeight = 'bold';
            app.CompareButton.FontColor = [0.0118 0.3294 0.9098];
            app.CompareButton.Position = [248 251 109 32];
            app.CompareButton.Text = 'Compare!';

            % Create LoadButton
            app.LoadButton = uibutton(app.LeftPanel, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.FontWeight = 'bold';
            app.LoadButton.FontColor = [0.0118 0.3294 0.9098];
            app.LoadButton.Position = [285 490 72 32];
            app.LoadButton.Text = {'Load'; ''};

            % Create KnownPeriodsLabel
            app.KnownPeriodsLabel = uilabel(app.LeftPanel);
            app.KnownPeriodsLabel.FontSize = 16;
            app.KnownPeriodsLabel.FontWeight = 'bold';
            app.KnownPeriodsLabel.FontColor = [0 0 0.5608];
            app.KnownPeriodsLabel.Position = [7 406 322 22];
            app.KnownPeriodsLabel.Text = 'Known Periods';

            % Create EvaluateButton
            app.EvaluateButton = uibutton(app.LeftPanel, 'push');
            app.EvaluateButton.ButtonPushedFcn = createCallbackFcn(app, @EvaluateButtonPushed, true);
            app.EvaluateButton.FontWeight = 'bold';
            app.EvaluateButton.FontColor = [0.0118 0.3294 0.9098];
            app.EvaluateButton.Position = [112 309 161 29];
            app.EvaluateButton.Text = 'Evaluate!';

            % Create UnknownFrequenciesLabel
            app.UnknownFrequenciesLabel = uilabel(app.LeftPanel);
            app.UnknownFrequenciesLabel.FontSize = 16;
            app.UnknownFrequenciesLabel.FontWeight = 'bold';
            app.UnknownFrequenciesLabel.FontColor = [0 0 0.5608];
            app.UnknownFrequenciesLabel.Position = [7 219 267 22];
            app.UnknownFrequenciesLabel.Text = 'Unknown Frequencies';

            % Create FindButton
            app.FindButton = uibutton(app.LeftPanel, 'push');
            app.FindButton.ButtonPushedFcn = createCallbackFcn(app, @FindButtonPushed, true);
            app.FindButton.FontWeight = 'bold';
            app.FindButton.FontColor = [0.0118 0.3294 0.9098];
            app.FindButton.Position = [220 189 110 29];
            app.FindButton.Text = 'Find!';

            % Create ExportDataLabel
            app.ExportDataLabel = uilabel(app.LeftPanel);
            app.ExportDataLabel.FontSize = 16;
            app.ExportDataLabel.FontWeight = 'bold';
            app.ExportDataLabel.FontColor = [0 0 0.5608];
            app.ExportDataLabel.Position = [7 85 267 22];
            app.ExportDataLabel.Text = 'Export Data';

            % Create ExportButton
            app.ExportButton = uibutton(app.LeftPanel, 'push');
            app.ExportButton.ButtonPushedFcn = createCallbackFcn(app, @ExportButtonPushed, true);
            app.ExportButton.FontWeight = 'bold';
            app.ExportButton.FontColor = [0.0118 0.3294 0.9098];
            app.ExportButton.Position = [247 43 110 29];
            app.ExportButton.Text = 'Export!';

            % Create PSOriginalvsModeledLabel
            app.PSOriginalvsModeledLabel = uilabel(app.LeftPanel);
            app.PSOriginalvsModeledLabel.FontWeight = 'bold';
            app.PSOriginalvsModeledLabel.FontColor = [0 0.2314 0.8118];
            app.PSOriginalvsModeledLabel.Position = [7 282 267 22];
            app.PSOriginalvsModeledLabel.Text = 'PS Original vs Modeled';

            % Create T2yEditFieldLabel
            app.T2yEditFieldLabel = uilabel(app.LeftPanel);
            app.T2yEditFieldLabel.HorizontalAlignment = 'center';
            app.T2yEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.T2yEditFieldLabel.Position = [123 377 36 22];
            app.T2yEditFieldLabel.Text = 'T2 [y]';

            % Create T2yEditField
            app.T2yEditField = uieditfield(app.LeftPanel, 'numeric');
            app.T2yEditField.FontColor = [0.0118 0.3294 0.9098];
            app.T2yEditField.Position = [116 346 49 29];

            % Create T3yEditFieldLabel
            app.T3yEditFieldLabel = uilabel(app.LeftPanel);
            app.T3yEditFieldLabel.HorizontalAlignment = 'center';
            app.T3yEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.T3yEditFieldLabel.Position = [175 377 36 22];
            app.T3yEditFieldLabel.Text = 'T3 [y]';

            % Create T3yEditField
            app.T3yEditField = uieditfield(app.LeftPanel, 'numeric');
            app.T3yEditField.FontColor = [0.0118 0.3294 0.9098];
            app.T3yEditField.Position = [168 346 49 29];

            % Create T4yEditFieldLabel
            app.T4yEditFieldLabel = uilabel(app.LeftPanel);
            app.T4yEditFieldLabel.HorizontalAlignment = 'center';
            app.T4yEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.T4yEditFieldLabel.Position = [227 377 36 22];
            app.T4yEditFieldLabel.Text = 'T4 [y]';

            % Create T4yEditField
            app.T4yEditField = uieditfield(app.LeftPanel, 'numeric');
            app.T4yEditField.FontColor = [0.0118 0.3294 0.9098];
            app.T4yEditField.Position = [220 346 49 29];

            % Create T5yEditFieldLabel
            app.T5yEditFieldLabel = uilabel(app.LeftPanel);
            app.T5yEditFieldLabel.HorizontalAlignment = 'center';
            app.T5yEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.T5yEditFieldLabel.Position = [279 377 36 22];
            app.T5yEditFieldLabel.Text = 'T5 [y]';

            % Create T5yEditField
            app.T5yEditField = uieditfield(app.LeftPanel, 'numeric');
            app.T5yEditField.FontColor = [0.0118 0.3294 0.9098];
            app.T5yEditField.Position = [272 346 49 29];

            % Create DirectoryButton
            app.DirectoryButton = uibutton(app.LeftPanel, 'push');
            app.DirectoryButton.ButtonPushedFcn = createCallbackFcn(app, @DirectoryButtonPushed, true);
            app.DirectoryButton.FontWeight = 'bold';
            app.DirectoryButton.FontColor = [0.0118 0.3294 0.9098];
            app.DirectoryButton.Position = [287 528 70 32];
            app.DirectoryButton.Text = 'Set!';

            % Create WorkDirectoryLabel
            app.WorkDirectoryLabel = uilabel(app.LeftPanel);
            app.WorkDirectoryLabel.FontWeight = 'bold';
            app.WorkDirectoryLabel.FontColor = [0.0118 0.3294 0.9098];
            app.WorkDirectoryLabel.Position = [7 534 103 22];
            app.WorkDirectoryLabel.Text = {'Work Directory'; ''};

            % Create WorkDirectoryEditField
            app.WorkDirectoryEditField = uieditfield(app.LeftPanel, 'text');
            app.WorkDirectoryEditField.FontColor = [0 0.149 1];
            app.WorkDirectoryEditField.Position = [109 530 164 29];
            app.WorkDirectoryEditField.Value = '.../INSAR...';

            % Create PSOriginalvsLSModeledLabel
            app.PSOriginalvsLSModeledLabel = uilabel(app.LeftPanel);
            app.PSOriginalvsLSModeledLabel.FontWeight = 'bold';
            app.PSOriginalvsLSModeledLabel.FontColor = [0 0.2314 0.8118];
            app.PSOriginalvsLSModeledLabel.Position = [7 156 267 22];
            app.PSOriginalvsLSModeledLabel.Text = 'PS Original vs LS Modeled';

            % Create PSCodeEditField_2Label
            app.PSCodeEditField_2Label = uilabel(app.LeftPanel);
            app.PSCodeEditField_2Label.FontWeight = 'bold';
            app.PSCodeEditField_2Label.FontColor = [0.0118 0.3294 0.9098];
            app.PSCodeEditField_2Label.Position = [7 130 55 22];
            app.PSCodeEditField_2Label.Text = 'PS Code';

            % Create NFrequenciesFind
            app.NFrequenciesFind = uieditfield(app.LeftPanel, 'numeric');
            app.NFrequenciesFind.ValueChangedFcn = createCallbackFcn(app, @NFrequenciesFindValueChanged, true);
            app.NFrequenciesFind.HorizontalAlignment = 'left';
            app.NFrequenciesFind.FontWeight = 'bold';
            app.NFrequenciesFind.FontColor = [0.0118 0.3294 0.9098];
            app.NFrequenciesFind.Position = [76 127 141 29];

            % Create CompareButton_2
            app.CompareButton_2 = uibutton(app.LeftPanel, 'push');
            app.CompareButton_2.ButtonPushedFcn = createCallbackFcn(app, @CompareButton_2Pushed, true);
            app.CompareButton_2.FontWeight = 'bold';
            app.CompareButton_2.FontColor = [0.0118 0.3294 0.9098];
            app.CompareButton_2.Position = [248 125 109 32];
            app.CompareButton_2.Text = 'Compare!';

            % Create LatminLabel
            app.LatminLabel = uilabel(app.LeftPanel);
            app.LatminLabel.HorizontalAlignment = 'right';
            app.LatminLabel.FontColor = [0.0118 0.3294 0.9098];
            app.LatminLabel.Position = [35 463 65 22];
            app.LatminLabel.Text = 'Lat min ';

            % Create LatminEditField
            app.LatminEditField = uieditfield(app.LeftPanel, 'numeric');
            app.LatminEditField.FontColor = [0.0118 0.3294 0.9098];
            app.LatminEditField.Position = [105 463 69 19];

            % Create LatmaxEditFieldLabel
            app.LatmaxEditFieldLabel = uilabel(app.LeftPanel);
            app.LatmaxEditFieldLabel.HorizontalAlignment = 'right';
            app.LatmaxEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.LatmaxEditFieldLabel.Position = [35 439 63 22];
            app.LatmaxEditFieldLabel.Text = 'Lat max';

            % Create LatmaxEditField
            app.LatmaxEditField = uieditfield(app.LeftPanel, 'numeric');
            app.LatmaxEditField.FontColor = [0.0118 0.3294 0.9098];
            app.LatmaxEditField.Position = [105 439 69 19];

            % Create LonminEditFieldLabel
            app.LonminEditFieldLabel = uilabel(app.LeftPanel);
            app.LonminEditFieldLabel.HorizontalAlignment = 'right';
            app.LonminEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.LonminEditFieldLabel.Position = [156 460 67 22];
            app.LonminEditFieldLabel.Text = 'Lon min';

            % Create LonminEditField
            app.LonminEditField = uieditfield(app.LeftPanel, 'numeric');
            app.LonminEditField.FontColor = [0.0118 0.3294 0.9098];
            app.LonminEditField.Position = [231 461 69 19];

            % Create LonmaxEditFieldLabel
            app.LonmaxEditFieldLabel = uilabel(app.LeftPanel);
            app.LonmaxEditFieldLabel.HorizontalAlignment = 'right';
            app.LonmaxEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.LonmaxEditFieldLabel.Position = [162 437 65 22];
            app.LonmaxEditFieldLabel.Text = 'Lon max';

            % Create LonmaxEditField
            app.LonmaxEditField = uieditfield(app.LeftPanel, 'numeric');
            app.LonmaxEditField.FontColor = [0.0118 0.3294 0.9098];
            app.LonmaxEditField.Position = [231 439 69 19];

            % Create SubsetLabel
            app.SubsetLabel = uilabel(app.LeftPanel);
            app.SubsetLabel.FontWeight = 'bold';
            app.SubsetLabel.FontColor = [0.0118 0.3294 0.9098];
            app.SubsetLabel.Position = [7 445 57 30];
            app.SubsetLabel.Text = 'Subset';

            % Create GoButton
            app.GoButton = uibutton(app.LeftPanel, 'push');
            app.GoButton.ButtonPushedFcn = createCallbackFcn(app, @GoButtonPushed, true);
            app.GoButton.FontWeight = 'bold';
            app.GoButton.FontColor = [0.0118 0.3294 0.9098];
            app.GoButton.Position = [307 446 50 28];
            app.GoButton.Text = 'Go!';

            % Create FrequencyFixedCheckBox
            app.FrequencyFixedCheckBox = uicheckbox(app.LeftPanel);
            app.FrequencyFixedCheckBox.Text = 'Frequency Fixed';
            app.FrequencyFixedCheckBox.FontColor = [0.0118 0.3294 0.9098];
            app.FrequencyFixedCheckBox.Position = [127 61 127 22];

            % Create FindFrequenciesCheckBox
            app.FindFrequenciesCheckBox = uicheckbox(app.LeftPanel);
            app.FindFrequenciesCheckBox.Text = 'Find Frequencies';
            app.FindFrequenciesCheckBox.FontColor = [0.0118 0.3294 0.9098];
            app.FindFrequenciesCheckBox.Position = [127 31 127 22];

            % Create NFrequenciesEditFieldLabel
            app.NFrequenciesEditFieldLabel = uilabel(app.LeftPanel);
            app.NFrequenciesEditFieldLabel.HorizontalAlignment = 'right';
            app.NFrequenciesEditFieldLabel.FontWeight = 'bold';
            app.NFrequenciesEditFieldLabel.FontColor = [0.0118 0.3294 0.9098];
            app.NFrequenciesEditFieldLabel.Position = [47 191 92 22];
            app.NFrequenciesEditFieldLabel.Text = 'N. Frequencies';

            % Create NFrequenciesEditField
            app.NFrequenciesEditField = uieditfield(app.LeftPanel, 'numeric');
            app.NFrequenciesEditField.FontWeight = 'bold';
            app.NFrequenciesEditField.FontColor = [0.0118 0.3294 0.9098];
            app.NFrequenciesEditField.Position = [160 191 48 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;
            app.RightPanel.Scrollable = 'on';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.RightPanel);
            app.TabGroup.Position = [7 12 520 638];

            % Create LoadedDataTab
            app.LoadedDataTab = uitab(app.TabGroup);
            app.LoadedDataTab.Title = 'Loaded Data';
            app.LoadedDataTab.BackgroundColor = [0.902 0.902 0.902];
            app.LoadedDataTab.ForegroundColor = [0 0.2314 0.8118];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.LoadedDataTab);
            title(app.UIAxes3, 'Title')
            xlabel(app.UIAxes3, 'Longitude')
            ylabel(app.UIAxes3, 'Latitude')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.Position = [17 64 484 518];

            % Create KnownPeriodsTab
            app.KnownPeriodsTab = uitab(app.TabGroup);
            app.KnownPeriodsTab.Title = 'Known Periods';
            app.KnownPeriodsTab.BackgroundColor = [0.902 0.902 0.902];
            app.KnownPeriodsTab.ForegroundColor = [0 0.2314 0.8118];

            % Create PlotLabel
            app.PlotLabel = uilabel(app.KnownPeriodsTab);
            app.PlotLabel.HorizontalAlignment = 'center';
            app.PlotLabel.FontWeight = 'bold';
            app.PlotLabel.Position = [104 573 313 22];
            app.PlotLabel.Text = 'Plot';

            % Create VariableDropDownLabel
            app.VariableDropDownLabel = uilabel(app.KnownPeriodsTab);
            app.VariableDropDownLabel.HorizontalAlignment = 'right';
            app.VariableDropDownLabel.Position = [75 557 65 22];
            app.VariableDropDownLabel.Text = 'Variable';

            % Create VariableDropDown
            app.VariableDropDown = uidropdown(app.KnownPeriodsTab);
            app.VariableDropDown.Items = {'m', 'q', 'stdev', 'SNR', 'f1', 'f1-A', 'f1-phi', 'f2', 'f2-A', 'f2-phi', 'f3', 'f3-A', 'f3-phi', 'f4', 'f4-A', 'f4-phi', 'f5', 'f5-A', 'f5-phi'};
            app.VariableDropDown.Position = [155 559 195 19];
            app.VariableDropDown.Value = 'm';

            % Create PlotButton
            app.PlotButton = uibutton(app.KnownPeriodsTab, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [365 557 76 23];
            app.PlotButton.Text = 'Plot';

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.KnownPeriodsTab);
            title(app.UIAxes4, 'Title')
            xlabel(app.UIAxes4, 'Longitude')
            ylabel(app.UIAxes4, 'Latitude')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.Position = [21 27 476 517];

            % Create KPPSComparisonTab
            app.KPPSComparisonTab = uitab(app.TabGroup);
            app.KPPSComparisonTab.Title = 'KP - PS Comparison';
            app.KPPSComparisonTab.BackgroundColor = [0.902 0.902 0.902];
            app.KPPSComparisonTab.ForegroundColor = [0 0.2314 0.8118];

            % Create UITable4
            app.UITable4 = uitable(app.KPPSComparisonTab);
            app.UITable4.ColumnName = {'PS_ref'; 'lon'; 'lat'; 'm'; 'q'; 'stdev'; 'SNR'; 'f1'; 'f1-A'; 'f1-phi'; 'f2'; 'f2-A'; 'f2-phi'; 'f3'; 'f3-A'; 'f3-phi'; 'f4'; 'f4-A'; 'f4-phi'; 'f5'; 'f5-A'; 'f5-phi'};
            app.UITable4.RowName = {};
            app.UITable4.Position = [43 72 441 79];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.KPPSComparisonTab);
            title(app.UIAxes5, 'Time Series')
            xlabel(app.UIAxes5, 'Time [Y]')
            ylabel(app.UIAxes5, '\Delta disp [mm]')
            zlabel(app.UIAxes5, 'Z')
            app.UIAxes5.Position = [47 265 437 302];

            % Create UnknownFrequenciesTab
            app.UnknownFrequenciesTab = uitab(app.TabGroup);
            app.UnknownFrequenciesTab.Title = 'Unknown Frequencies';
            app.UnknownFrequenciesTab.BackgroundColor = [0.902 0.902 0.902];
            app.UnknownFrequenciesTab.ForegroundColor = [0 0.2314 0.8118];

            % Create PlotButton_2
            app.PlotButton_2 = uibutton(app.UnknownFrequenciesTab, 'push');
            app.PlotButton_2.ButtonPushedFcn = createCallbackFcn(app, @PlotButton_2Pushed, true);
            app.PlotButton_2.Position = [365 558 76 23];
            app.PlotButton_2.Text = 'Plot';

            % Create VariableDropDown_2Label
            app.VariableDropDown_2Label = uilabel(app.UnknownFrequenciesTab);
            app.VariableDropDown_2Label.HorizontalAlignment = 'right';
            app.VariableDropDown_2Label.Position = [75 558 65 22];
            app.VariableDropDown_2Label.Text = 'Variable';

            % Create VariableDropDown_2
            app.VariableDropDown_2 = uidropdown(app.UnknownFrequenciesTab);
            app.VariableDropDown_2.Items = {'m', 'q', 'stdev', 'SNR', 'f1', 'f1-A', 'f1-phi', 'f2', 'f2-A', 'f2-phi', 'f3', 'f3-A', 'f3-phi', 'f4', 'f4-A', 'f4-phi', 'f5', 'f5-A', 'f5-phi'};
            app.VariableDropDown_2.Position = [155 559 195 19];
            app.VariableDropDown_2.Value = 'm';

            % Create PlotLabel_2
            app.PlotLabel_2 = uilabel(app.UnknownFrequenciesTab);
            app.PlotLabel_2.HorizontalAlignment = 'center';
            app.PlotLabel_2.FontWeight = 'bold';
            app.PlotLabel_2.Position = [104 573 313 22];
            app.PlotLabel_2.Text = 'Plot';

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.UnknownFrequenciesTab);
            title(app.UIAxes6, 'Title')
            xlabel(app.UIAxes6, 'Longitude')
            ylabel(app.UIAxes6, 'Latitude')
            zlabel(app.UIAxes6, 'Z')
            app.UIAxes6.Position = [21 23 476 517];

            % Create UFPSComparisonTab
            app.UFPSComparisonTab = uitab(app.TabGroup);
            app.UFPSComparisonTab.Title = 'UF - PS Comparison';
            app.UFPSComparisonTab.BackgroundColor = [0.902 0.902 0.902];
            app.UFPSComparisonTab.ForegroundColor = [0 0.2314 0.8118];

            % Create UITable5
            app.UITable5 = uitable(app.UFPSComparisonTab);
            app.UITable5.ColumnName = {'PS_ref'; 'lon'; 'lat'; 'm'; 'q'; 'stdev'; 'SNR'; 'f1'; 'f1-A'; 'f1-phi'; 'f2'; 'f2-A'; 'f2-phi'; 'f3'; 'f3-A'; 'f3-phi'; 'f4'; 'f4-A'; 'f4-phi'; 'f5'; 'f5-A'; 'f5-phi'};
            app.UITable5.RowName = {};
            app.UITable5.Position = [15 252 498 74];

            % Create UIAxes8
            app.UIAxes8 = uiaxes(app.UFPSComparisonTab);
            title(app.UIAxes8, 'Spectral Density')
            xlabel(app.UIAxes8, 'Frequency')
            ylabel(app.UIAxes8, 'Power')
            zlabel(app.UIAxes8, 'Z')
            app.UIAxes8.XTick = [0 0.2 0.4 0.6 0.8 1];
            app.UIAxes8.Position = [18 34 495 195];

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.UFPSComparisonTab);
            title(app.UIAxes7, 'Time Series')
            xlabel(app.UIAxes7, 'time [Y]')
            ylabel(app.UIAxes7, '\Delta disp [mm]')
            zlabel(app.UIAxes7, 'Z')
            app.UIAxes7.Position = [18 360 490 204];

            % Show the figure after all components are created
            app.PatientsDisplayUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TimeSAPS_10

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.PatientsDisplayUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.PatientsDisplayUIFigure)
        end
    end
end