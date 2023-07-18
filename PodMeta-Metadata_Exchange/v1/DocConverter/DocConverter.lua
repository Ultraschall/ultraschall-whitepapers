  --[[
  ################################################################################
  # 
  # Copyright (c) 2014-2021 Ultraschall (http://ultraschall.fm)
  # 
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  # 
  # The above copyright notice and this permission notice shall be included in
  # all copies or substantial portions of the Software.
  # 
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  # THE SOFTWARE.
  # 
  ################################################################################
  --]]

if reaper.file_exists(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")==true then
  dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")
else
  dofile(reaper.GetResourcePath().."/Scripts/Reaper_Internals/ultraschall_api.lua")
end

StartTime=reaper.time_precise()
-- increment build-version-numbering
local retval, string2 = reaper.BR_Win32_GetPrivateProfileString("Ultraschall-Api-Build", "API-Build", "", ultraschall.Api_Path.."/IniFiles/ultraschall_api.ini")

-- init variables
Tempfile=ultraschall.Api_Path.."/temp/"

Infilename={}
Infilename=ultraschall.Api_Path.."/misc/Podmeta_Standard_v1_WIP.USDocML"


Outfile=ultraschall.Api_Path.."/Documentation/PodMeta_v1.html"

-- Reaper-version and tagline from extstate
versionnumbering=reaper.GetExtState("ultraschall_api", "ReaperVerNr")
tagline=reaper.GetExtState("ultraschall_api", "Tagline")


found_usdocblocs, blocs = ultraschall.Docs_GetAllUSDocBlocsFromString(ultraschall.ReadFullFile(Infilename))

-- Let's build an index
Index="<div class=\"index\" style=\"padding-left:4%; width:96%;\"><div style=\"font-size:30;\">PodMeta v1</div><br>Draft: "..os.date():match("(.*) ").."<br><br>a metadata-exchange-format for podcasts<br>authored by Meo-Ada Mespotine</div><div class=\"index\" style=\"padding-left:4%; width:96%;\">"
for i=1, found_usdocblocs do
   slug = ultraschall.Docs_GetUSDocBloc_Slug(blocs[i])
   title = ultraschall.Docs_GetUSDocBloc_Title(blocs[i], 1)
   count, chapters, spok_lang = ultraschall.Docs_GetUSDocBloc_ChapterContext(blocs[i], 1)
   if chapters[1]~=oldchapters then Index=Index.."<br>"..chapters[1].."<br>\n" oldchapters=chapters[1] end
   Index=Index.."&nbsp;&nbsp;<a href=\"#"..slug.."\">"..title.."</a><br>\n"
end
Index=Index.."</div>"

-- Let's build the entries
for i=1, found_usdocblocs do
  Index=Index.."\n<div class=\"entries\" style=\"padding-left:4%; width:96%;\">"
  slug = ultraschall.Docs_GetUSDocBloc_Slug(blocs[i])
  title = ultraschall.Docs_GetUSDocBloc_Title(blocs[i], 1)
  description = " "..ultraschall.Docs_GetUSDocBloc_Description(blocs[i], true, 1)
  description=string.gsub(description, "\n", "<br>\n")
  --description=string.gsub(description, "%s", "&nbsp;\n")
  Index=Index.."<br><b><a id=\""..slug.."\"><a href=\"#"..slug.."\">"..title.."</a></a></b><br><br>"..description
  Index=Index.."</div><br><hr style=\"width:92%;\">"
end

SLEM()
print2(Index:match("Unfinished"))
ultraschall.WriteValueToFile("c:\\PodMeta_v1.html", Index)
