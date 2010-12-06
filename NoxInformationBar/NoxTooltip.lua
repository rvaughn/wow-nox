---------------------------------------------------------------------------
-- Nox Information Bar
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Tooltip Functions
---------------------------------------------------------------------------

function NoxInformationBar_SetTooltip()
   GameTooltip:ClearLines();
   local i, line;
   for i, line in ipairs(Nox.Player.Tooltip.Content) do
      if (line.left and line.right) then
         GameTooltip:AddDoubleLine(NoxInformationBar_FormatText(line.left), NoxInformationBar_FormatText(line.right));
      elseif (line.left) then
         GameTooltip:AddLine(NoxInformationBar_FormatText(line.left));
      else
         GameTooltip:AddLine(" ");
      end
   end
end

function NoxInformationBar_ShowTooltip()
    if (Nox.Player.Tooltip.State) then
        GameTooltip:SetOwner(NoxInformationBarFrame, "ANCHOR_NONE");
        GameTooltip:ClearAllPoints();
        GameTooltip:SetPoint(Nox.Player.Tooltip.Anchor, Nox.Player.Tooltip.Parent, Nox.Player.Tooltip.Anchor, Nox.Player.Tooltip.X, Nox.Player.Tooltip.Y);
        NoxInformationBar_SetTooltip();
        GameTooltip:SetBackdropColor(0, 0, 0, 1);
        GameTooltip:Show();
    end
end
