function proj_main(Str, k, SNRdB, MC, flag)

if strcmpi(Str,'PAM')
    Cost = proj_PAM_generator(k);    
elseif strcmpi(Str,'PPM')
    Cost = proj_PPM_generator(k);
elseif strcmpi(Str,'PSK')
    Cost = proj_PSK_generator(k);
elseif strcmpi(Str,'QAM')
    Cost = proj_QAM_generator(k);
else
    fprintf('Str deve essere PAM / PPM / PSK / QAM \n')
    return;
end

if flag

else
    proj_stima_Pe(SNRdB, Cost, MC)
end