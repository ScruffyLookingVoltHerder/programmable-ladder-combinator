--built-in UDTs
local UDT_Tags={}
local UDTS={
    IOgroup={
        builtin=true,
        tags={
            {type="IOPoint",name="PT1"},
            {type="IOPoint",name="PT2"},
            {type="IOPoint",name="PT3"},
            {type="IOPoint",name="PT4"}
            }
    },
   IOPoint= {
        builtin=true,
        tags={
            {type="SIGSET",name="R_IN",comment ="Red in",write=false},
            {type="SIGSET",name="R_OUT",comment ="Red out",write=true},
            {type="SIGSET",name="G_IN",comment ="Green in",write=false},
            {type="SIGSET",name="G_OUT",comment ="Green out",write=true},
            {type="BOOL",name="R_CEN",comment ="Red change event enable",write=true},
            {type="BOOL",name="G_CEN",comment ="Green change event enable",write=true},
            {type="BOOL",name="R_CEV",comment ="Red signal changed",write=false},
            {type="BOOL",name="G_CEV",comment ="Green signal changed",write=false},
            }
    },
    Timer= {
        builtin=true,
        tags={
            {type="INT",name="St", comment="Start tick",write=false,BitComments={}},
            {type="INT",name="Acc",comment ="Accumulator",write=false,BitComments={}},
            {type="INT",name="Pre",comment ="Preset",write=true,BitComments={}},
            {type="BOOL",name="EN",comment ="Timer enabled",write=false},
            {type="BOOL",name="TT",comment ="Timing",write=false},
            {type="BOOL",name="DN",comment ="Done",write=false},
            }
    },
    Counter= {
        builtin=true,
        tags={
            {type="BOOL",name="CU",comment ="Counted up",write=false},
            {type="BOOL",name="CD",comment ="Counted down",write=false},
            {type="INT",name="Acc",comment ="Accumulator",write=false,BitComments={}},
            {type="INT",name="Pre",comment ="Preset",write=true,BitComments={}},

            }
    },


}

UDT_Tags.builtin_UDTs=UDTS

UDT_Tags.build_tag=function(Tags,name,type,comment,UDTs)

    local newtag={}

    newtag.type=type
    newtag.comment=comment

    if type =="SIGSET" then
         newtag.value={}

    elseif type=="BOOL" then
        newtag.value=false

    elseif type=="INT" then
        newtag.value=0
        newtag.BitComments={}

    else
        newtag.value={}
        local UDT=UDTs[type]

        for k,v in ipairs(UDT.tags) do

            UDT_Tags.build_tag(newtag.value,v.name,v.type,v.comment,UDTs)
            newtag.value[v.name].write=v.write

            if v.type =="INT" and v.BitComments then
                newtag.value[v.name].BitComments=table.deepcopy(v.BitComments)
            end
        end


    end

Tags[name]=newtag
    
end




return UDT_Tags
